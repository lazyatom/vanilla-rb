require 'soup'
require 'ostruct'

module Vanilla
  class App
    include Vanilla::Routes

    class << self
      attr_reader :config
      def configure(&block)
        reset! unless @config
        yield @config
        self
      end
      def reset!
        @config = OpenStruct.new
      end
    end

    attr_reader :request, :response, :config, :soup

    def class_config
      if self.class.config
        {:soup => self.class.config.soup,
         :soups => self.class.config.soups,
         :root => self.class.config.root,
         :root_snip => self.class.config.root_snip,
         :renderers => self.class.config.renderers,
         :default_layout_snip => self.class.config.default_layout_snip,
         :default_renderer => self.class.config.default_renderer}
      else
        {}
      end
    end

    # Create a new Vanilla application
    # Configuration options:
    #
    #  :soup - provide the path to the soup data
    #  :soups - provide an array of paths to soup data
    #  :root - the directory that the soup paths are relative to;
    #          defaults to Dir.pwd
    #  :renderers - a hash of names to classes
    #  :default_renderer - the class to use when no renderer is provided;
    #                      defaults to 'Vanilla::Renderers::Base'
    #  :default_layout_snip - the snip to use as a layout when rendering to HTML;
    #                         defaults to 'layout'
    #  :root_snip - the snip to load for the root ('/') url;
    #               defaults to 'start'
    def initialize(additional_configuration={})
      @config = class_config.merge(additional_configuration)
      @config[:root] ||= Dir.pwd
      @root_directory = @config[:root]
      @config[:soups] = ["soups/base", "soups/system"] if @config[:soups].nil?
      @config[:default_layout_snip]  ||= 'layout'
      @config[:default_renderer] ||= Vanilla::Renderers::Base
      @soup = prepare_soup(config)
      prepare_renderers(config[:renderers])
    end

    # Returns a Rack-appropriate 3-element array (via Rack::Response#finish)
    def call(env)
      env['vanilla.app'] = self
      @request = Vanilla::Request.new(env, self)
      @response = Rack::Response.new

      begin
        output = formatted_render(request.snip, request.part, request.format)
      rescue => e
        @response.status = 500
        output = e.to_s + e.backtrace.join("\n")
      end
      response_format = request.format
      response_format = 'plain' if response_format == 'raw'
      @response['Content-Type'] = "text/#{response_format}"
      @response.write(output)
      @response.finish # returns the array
    end

    def formatted_render(snip, part=nil, format=nil)
      case format
      when 'html', nil
        layout = layout_for(snip)
        if layout == snip
          "Rendering of the current layout would result in infinite recursion."
        else
          render(layout)
        end
      when 'raw', 'css', 'js'
        Renderers::Raw.new(self).render(snip, part)
      when 'text', 'atom', 'xml'
        render(snip, part)
      else
        raise "Unknown format '#{format}'"
      end
    end

    # render a snip using either the renderer given, or the renderer
    # specified by the snip's "render_as" property, or Render::Base
    # if nothing else is given.
    def render(snip, part=:content, args=[], enclosing_snip=snip)
      rendering(snip) do |renderer|
        renderer.render(snip, part, args, enclosing_snip)
      end
    end

    # Returns the renderer class for a given snip
    def renderer_for(snip)
      if snip
        find_renderer(snip.render_as || snip.extension)
      else
        config[:default_renderer]
      end
    end

    def default_layout_snip
      soup[config[:default_layout_snip]]
    end

    def layout_for(snip)
      if snip
        renderer_for(snip).new(self).layout_for(snip)
      else
        default_layout_snip
      end
    end

    def snip(attributes)
      @soup << attributes
    end

    def register_renderer(klass, *types)
      types.each do |type|
        if klass.is_a?(String)
          klass = klass.split("::").inject(Object) { |o, name| o.const_get(name) }
        end
        @renderers[type.to_s] = klass
      end
    end

    private

    def prepare_renderers(additional_renderers={})
      @renderers = Hash.new { config[:default_renderer] }
      @renderers.merge!({
        "base" => Vanilla::Renderers::Base,
        "markdown" => Vanilla::Renderers::Markdown,
        "bold" => Vanilla::Renderers::Bold,
        "erb" => Vanilla::Renderers::Erb,
        "rb" => Vanilla::Renderers::Ruby,
        "ruby" => Vanilla::Renderers::Ruby,
        "haml" => Vanilla::Renderers::Haml,
        "raw" => Vanilla::Renderers::Raw,
        "textile" => Vanilla::Renderers::Textile
      })
      additional_renderers.each { |name, klass| register_renderer(klass, name) } if additional_renderers
    end

    def find_renderer(name)
      @renderers[(name ? name.downcase : nil)]
    end

    def rendering(snip)
      renderer_instance = renderer_for(snip).new(self)
      yield renderer_instance
    rescue Exception => e
      snip_name = snip ? snip.name : nil
      "<pre>[Error rendering '#{snip_name}' - \"" +
        e.message.gsub("<", "&lt;").gsub(">", "&gt;") + "\"]\n" +
        e.backtrace.join("\n").gsub("<", "&lt;").gsub(">", "&gt;") + "</pre>"
    end

    def prepare_soup(config)
      if config[:soups]
        backends = [config[:soups]].flatten.map do |path| 
          ::Soup::Backends::FileBackend.new(File.expand_path(path, config[:root]))
        end
        ::Soup.new(::Soup::Backends::MultiSoup.new(*backends))
      else
        raise "No soups defined!"
      end
    end
  end
end
