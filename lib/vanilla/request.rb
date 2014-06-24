require "cgi"

module Vanilla
  # Create a request with symbolised access to the params, and some special
  # accessors to the snip, part and format based on our routing.
  class Request
    attr_reader :snip_name, :part, :format, :method, :env

    def initialize(env, app)
      @env = env
      @rack_request = Rack::Request.new(env)
      @app = app
      determine_request_uri_parts
    end

    # returns the parameters of the request, with every key as a symbol
    def params
      @symbolised_params ||= @rack_request.params.inject({}) { |p, (k,v)| p[k.to_sym] = v; p }
    end

    # Returns the snip referenced by the request's URL. Performs no exception
    # handling, so if the snip does not exist, an exception will be thrown.
    def snip
      @app.soup[snip_name]
    end

    def method_missing(name, *args)
      if @rack_request.respond_to?(name)
        @rack_request.send(name, *args)
      else
        super
      end
    end

    private

    def determine_request_uri_parts
      @snip_name, @part, @format = Vanilla::Routing.parse(@rack_request.path_info)
      @snip_name ||= @app.config.root_snip
      @format ||= 'html'
      @method = (params.delete(:_method) || @rack_request.request_method).downcase
    end
  end
end
