require 'soup'
require 'delegate'

module Vanilla
  class SoupWithTimestamps < DelegateClass(Soup)
    def initialize(config)
      super(Soup.new(config))
    end
    
    def <<(attributes)
      attributes[:created_at] ||= Time.now
      attributes[:updated_at] = Time.now
      super
    end
    
    def new_snip(attributes)
      Snip.new(attributes, self)
    end
  end
end
    