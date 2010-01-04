require 'rack/utils'

# Heavily based on ActionDispatch::Static
module Vanilla
  class Static
    def initialize(app, root)
      @app = app
      @file_server = ::Rack::File.new(root)
    end

    def call(env)
      path   = env['PATH_INFO'].chomp('/')
      method = env['REQUEST_METHOD']

      if %w(GET HEAD).include?(method) && file_exist?(path)
        @file_server.call(env)
      else
        @app.call(env)
      end
    end

    private
      def file_exist?(path)
        full_path = File.join(@file_server.root, ::Rack::Utils.unescape(path))
        File.file?(full_path) && File.readable?(full_path)
      end
  end
end