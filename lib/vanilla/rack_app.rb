require 'vanilla/app'

gem 'rack'
require 'rack'


module Vanilla
  class RackApp
    
    # Create a new Vanilla Rack Application.
    # Set the dreamhost_fix parameter to true to get the request path from the SCRIPT_URL
    # environment variable, rather than the request.path_info method.
    def initialize(dreamhost_fix=false)
      Soup.prepare
      @dreamhost_fix = dreamhost_fix
    end
    
    def request_for(env)
      Vanilla::Request.new(Rack::Request.new(env), @dreamhost_fix)
    end
    
    # The call method required by all good Rack applications
    def call(env)
      Vanilla::App.new(request_for(env)).present
    end
  end
end