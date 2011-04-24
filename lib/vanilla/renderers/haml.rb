require 'haml'

module Vanilla::Renderers
  class Haml < Base
    def prepare(snip, part=:content, args=[], enclosing_snip=snip)
      @snip = snip
    end
    
    def process_text(content)
      ::Haml::Engine.new(content).render(binding)
    end
  end
end