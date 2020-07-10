require 'rubygems'
require 'bluecloth'

module Vanilla::Renderers
  class Markdown < Base
    def process_text(content)
      BlueCloth.new(content).to_html
    end
  end
end
