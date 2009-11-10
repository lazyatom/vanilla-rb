require 'warden'

module Vanilla
  module Authentication
    class Warden < Base
      def initialize(app)
        super
        ::Warden::Strategies.add(:vanilla, Vanilla::Authentication::Warden::Strategy)
      end

      def authenticated?
        @app.request.env['warden'].authenticated?
      end

      def user
        @app.request.env['warden'].user
      end

      def authenticate!
        @app.request.env['warden'].authenticate!
      end

      def logout
        @app.request.env['warden'].logout
      end

      class Strategy < ::Warden::Strategies::Base
        def valid?
          params["name"] || params["password"]
        end

        def authenticate!
          if env['vanilla.app'].config[:credentials][params["name"]] == MD5.md5(params["password"]).to_s
            success!(params["name"])
          else
            redirect!("/login")
          end
        end
      end
    end
  end
end