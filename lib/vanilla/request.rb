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

    def params
      # Don't you just love how terse functional programming tends to look like maths?
      @symbolised_params ||= @rack_request.params.inject({}) { |p, (k,v)| p[k.to_sym] = v; p }
    end

    # Returns the snip referenced by the request's URL. Performs no exception
    # handling, so if the snip does not exist, an exception will be thrown.
    def snip
      @app.soup[snip_name]
    end

    def cookies
      @rack_request.cookies
    end

    def ip
      @rack_request.env["REMOTE_ADDR"]
    end

    def session
      @rack_request.env["rack.session"]
    end

    def authenticated?
      @app.authenticator.authenticated?
    end

    def user
      @app.authenticator.user
    end

    def authenticate!
      @app.authenticator.authenticate!
    end

    def logout
      @app.authenticator.logout
    end

    private

    def determine_request_uri_parts
      @snip_name, @part, @format = request_uri_parts(@rack_request)
      @format ||= 'html'
      @method = (params.delete(:_method) || @rack_request.request_method).downcase
    end

    def uri_path(request)
      request.path_info
    end

    URL_ROOT          = /\A\/\Z/                                  # i.e. /
    URL_SNIP          = /\A\/([\w\-\s]+)(\/|\.(\w+))?\Z/            # i.e. /start, /start.html
    URL_SNIP_AND_PART = /\A\/([\w\-\s]+)\/([\w\-\s]+)(\/|\.(\w+))?\Z/ # i.e. /blah/part, /blah/part.raw

    # Returns an array of the requested snip, part and format
    def request_uri_parts(request)
      case CGI.unescape(uri_path(request))
      when URL_ROOT
        [@app.config[:root_snip] || 'start', nil, 'html']
      when URL_SNIP
        [$1, nil, $3]
      when URL_SNIP_AND_PART
        [$1, $2, $4]
      else
        []
      end
    end

  end
end
