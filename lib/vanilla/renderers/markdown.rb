require 'rubygems'
require 'bluecloth'

module Vanilla::Renderers
  class Markdown < Base
    def process_text(content)
      html = BlueCloth.new(content).to_html
      html.gsub(/<pre>(.*)<\/pre>/m) do |match|
        self.class.escape_curly_braces(match)
      end
    end
  end
end
