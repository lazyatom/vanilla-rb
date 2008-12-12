module Vanilla
  module SnipHandling
    class MissingSnipException < Exception; end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def snip(name)
        snip = Soup[name]
        if snip.is_a?(Array) && snip.empty?
          return nil
        end
        snip
      end

      def snip!(name)
        snip = snip(name)
        raise MissingSnipException, "can't find '#{name}'" unless snip
      end

      def snip_exists?(name)
        snip = Soup[name]
        if snip.is_a?(Array) && snip.empty?
          false
        else
          true
        end
      end
    end
  end
end