require 'vanilla/request'
require 'vanilla/authentication'
require 'vanilla/routes'
require 'vanilla/soup/timestamp_backend'

# Require the base set of renderers
require 'vanilla/renderers/base'
require 'vanilla/renderers/raw'
require 'vanilla/renderers/erb'


module Vanilla
  class App
    include Routes

    attr_reader :request, :response, :config, :soup
    attr_accessor :authenticator

    def initialize(config_file=nil)
      prepare_configuration(config_file)
      @soup = prepare_soup(config)
      @authenticator = Vanilla::Authentication::Base.new(self)
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
        output = e.to_s
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
        Renderers::Erb.new(self).render(soup['system'], :main_template)
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
      "<pre>[Error rendering '#{snip.name}' - \"" +
        e.message.gsub("<", "&lt;").gsub(">", "&gt;") + "\"]\n" +
        e.backtrace.join("\n").gsub("<", "&lt;").gsub(">", "&gt;") + "</pre>"
    end

    # Returns the renderer class for a given snip
    def renderer_for(snip)
      return Renderers::Base unless snip.render_as && !snip.render_as.empty?
      Vanilla::Renderers.const_get(snip.render_as)
    end

    # Other things can call this when a snip cannot be loaded.
    def render_missing_snip(snip_name)
      "[snip '#{snip_name}' cannot be found]"
    end

    def snip(attributes)
      @soup << attributes
    end

    private

    def prepare_configuration(config_file)
      config_file ||= "config.yml"
      @config = YAML.load(File.open(config_file)) rescue {}
      @config[:filename] = config_file
      def @config.save!
        File.open(self[:filename], 'w') { |f| f.puts self.to_yaml }
      end
    end

    def prepare_soup(config)
      if config[:soups]
        backends = [config[:soups]].flatten.map { |path| Vanilla::Soup::TimestampBackend.new(::Soup::Backends::YAMLBackend.new(path)) }
        ::Soup.new(::Soup::Backends::MultiSoup.new(*backends))
      else
        ::Soup.new(Vanilla::Soup::TimestampBackend.new(::Soup::Backends::YAMLBackend.new(config[:soup])))
      end
    end
  end
end
