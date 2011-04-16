require 'soup'
require 'vanilla/request'
require 'vanilla/routes'

# Require the base set of renderers
require 'vanilla/renderers/base'
require 'vanilla/renderers/raw'
require 'vanilla/renderers/erb'

module Vanilla
  class App
    include Routes

    attr_reader :request, :response, :config, :soup

    def initialize(config={})
      @config = config
      if @config[:soup].nil? && @config[:soups].nil?
        @config.merge!(:soup => File.expand_path("soup"))
      end
      @soup = prepare_soup(config)
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
        render(layout_for(snip))
      when 'raw', 'css', 'js'
        Renderers::Raw.new(self).render(snip, part || :content)
      when 'text', 'atom', 'xml'
        render(snip, part || :content)
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

    # Given the snip and parameters, yield an instance of the appropriate
    # Vanilla::Render::Base subclass
    def rendering(snip)
      renderer_instance = renderer_for(snip).new(self)
      yield renderer_instance
    rescue Exception => e
      snip_name = snip ? snip.name : nil
      "<pre>[Error rendering '#{snip_name}' - \"" +
        e.message.gsub("<", "&lt;").gsub(">", "&gt;") + "\"]\n" +
        e.backtrace.join("\n").gsub("<", "&lt;").gsub(">", "&gt;") + "</pre>"
    end

    # Returns the renderer class for a given snip
    def renderer_for(snip)
      if snip && snip.render_as && !snip.render_as.empty?
        Vanilla::Renderers.const_get(snip.render_as)
      elsif snip && snip.extension && !snip.extension.empty?
        Vanilla::Renderers.const_get(renderer_for_extension(snip.extension))
      else
        default_renderer
      end
    end

    def default_layout_snip
      soup[config[:default_layout_snip] || 'layout']
    end

    def default_renderer
      config[:default_renderer] || Vanilla::Renderers::Base
    end

    def layout_for(snip)
      if snip
        renderer_for(snip).new(self).layout_for(snip)
      else
        default_layout_snip
      end
    end

    # Other things can call this when a snip cannot be loaded.
    def render_missing_snip(snip_name)
      "[snip '#{snip_name}' cannot be found]"
    end

    def snip(attributes)
      @soup << attributes
    end

    private

    def renderer_for_extension(extension)
      mapping = Hash.new("Base")
      mapping["markdown"] = "Markdown"
      mapping["textile"] = "Textile"
      mapping["erb"] = "Erb"
      mapping["rb"] = "Ruby"
      mapping["haml"] = "Haml"
      mapping[extension]
    end

    def prepare_soup(config)
      if config[:soups]
        backends = [config[:soups]].flatten.map { |path| ::Soup::Backends::FileBackend.new(path) }
        ::Soup.new(::Soup::Backends::MultiSoup.new(*backends))
      else
        ::Soup.new(::Soup::Backends::FileBackend.new(config[:soup]))
      end
    end
  end
end
