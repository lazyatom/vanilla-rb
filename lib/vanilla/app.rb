require 'soup'

module Vanilla

  # This is the main App class for Vanilla applications; this should
  # be subclassed for each instance of Vanilla that you want to run.
  class App
    include Vanilla::Routing
    class FormatNotFound < RuntimeError; end

    class << self
      attr_reader :config
      def configure(&block)
        reset! unless instance_variable_defined?(:@config)
        yield @config
        self
      end
      def reset!
        @config = Vanilla::Config.new
      end
      def inherited(app)
        Vanilla.apps << app
      end
    end

    attr_reader :request, :response, :soup

    def initialize
      @renderers = Hash.new { config.default_renderer }
      @soup = config.soup || prepare_soup
      prepare_renderers
    end

    def config
      self.class.config
    end

    # Returns a Rack-appropriate 3-element array (via Rack::Response#finish)
    def call(env)
      env['vanilla.app'] = self
      @request = Vanilla::Request.new(env, self)
      @response = Rack::Response.new

      begin
        output = render_in_format(request.snip, request.part, request.format)
        @response.status = request.snip ? 200 : 404
      rescue FormatNotFound => e
        @response.status = 404
        output = e.to_s
      rescue => e
        raise e if config.raise_errors
        @response.status = 500
        output = e.to_s + e.backtrace.join("\n")
      end
      response_format = request.format
      response_format = 'plain' if response_format == 'raw'
      @response['Content-Type'] = "text/#{response_format}"
      output = "" if @request.method == "head"
      @response.write(output)
      @response.finish # returns the array
    end

    # render a snip using either the renderer given, or the renderer
    # specified by the snip's "render_as" property, or Render::Base
    # if nothing else is given.
    #
    # This method can be useful if a dynasnip or other part of the
    # system needs to get a fully rendered version of a snip.
    def render(snip, part=:content, args=[], enclosing_snip=snip)
      rendering_and_handling_errors(snip) do |renderer|
        renderer.render(snip, part, args, enclosing_snip)
      end
    end

    # Returns the renderer class for a given snip
    def renderer_for(snip)
      if snip
        renderer_name = snip.render_as || snip.extension
        renderer_name = nil if renderer_name == ''
      else
        renderer_name = nil
      end
      if renderer_name
        find_renderer(renderer_name)
      else
        config.default_renderer
      end
    end

    def default_layout_snip
      soup[config.default_layout_snip]
    end

    def missing_layout_snip
      soup[config.missing_layout_snip]
    end

    def register_renderer(klass, *types)
      types.each do |type|
        if klass.is_a?(String)
          klass = klass.split("::").inject(Object) { |o, name| o.const_get(name) }
        end
        @renderers[type.to_s] = klass
      end
    end

    def atom_feed(options={})
      AtomFeed.new(options.merge(app: self))
    end

    private

    def prepare_renderers
      config.renderers.each { |name, klass| register_renderer(klass, name) }
    end

    def find_renderer(name)
      if @renderers.has_key?(name.downcase)
        @renderers[name.downcase]
      else
        raise MissingRendererError.new(name)
      end
    end

    def rendering_and_handling_errors(snip)
      renderer_instance = renderer_for(snip).new(self)
      yield renderer_instance
    rescue Exception => e
      raise e if config.raise_errors
      response.status = 500
      snip_name = snip ? snip.name : nil
      "<pre>[Error rendering '#{snip_name}' - \"" +
        e.message.gsub("<", "&lt;").gsub(">", "&gt;") + "\"]\n" +
        e.backtrace.join("\n").gsub("<", "&lt;").gsub(">", "&gt;") + "</pre>"
    end

    def render_in_format(snip, part=nil, format=nil)
      format = nil unless snip
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
        raise FormatNotFound, "Unknown format '#{format}'"
      end
    end

    def layout_for(snip)
      if snip
        renderer_for(snip).new(self).layout_for(snip)
      else
        missing_layout_snip
      end
    end

    def prepare_soup
      if config.soups
        backends = [config.soups].flatten.map do |path|
          ::Soup::Backends::FileBackend.new(File.expand_path(path, config.root))
        end
        ::Soup.new(::Soup::Backends::MultiSoup.new(*backends))
      else
        raise "No soups defined!"
      end
    end
  end
end
