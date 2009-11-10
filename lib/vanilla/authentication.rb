module Vanilla
  module Authentication
    # A pass-through authenticator, which never
    # requires a login
    class Base
      def initialize(app)
        @app = app
      end

      def authenticated?
        true
      end

      def user
      end

      def authenticate!
      end

      def logout
      end
    end
  end
end
