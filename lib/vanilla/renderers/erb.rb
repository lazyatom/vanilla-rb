require 'erb'

module Vanilla::Renderers
  class Erb < Base
    def prepare(snip, part=:content, args=[], enclosing_snip=snip)
      @snip = snip
    end

    def process_text(content)
      ERB.new(content).result(binding)
    end
  end
end
