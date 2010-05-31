require 'soup'

module Vanilla
  module Soup
    class TimestampBackend
      def initialize(backend)
        @backend = backend
      end

      def save_snip(attributes)
        attributes[:created_at] ||= Time.now
        attributes[:created_at] = Time.parse(attributes[:created_at]) if attributes[:created_at].is_a?(String)
        attributes[:updated_at] = Time.now
        @backend.save_snip(attributes)
      end

      def method_missing(*args)
        @backend.__send__(*args)
      end
    end
  end
end
