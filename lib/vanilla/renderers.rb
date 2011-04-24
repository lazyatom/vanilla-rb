module Vanilla
  module Renderers
    autoload :Base, "vanilla/renderers/base"
    autoload :Bold, "vanilla/renderers/bold"
    autoload :Erb, "vanilla/renderers/erb"
    autoload :Haml, "vanilla/renderers/haml"
    autoload :Markdown, "vanilla/renderers/markdown"
    autoload :Raw, "vanilla/renderers/raw"
    autoload :Ruby, "vanilla/renderers/ruby"
    autoload :Textile, "vanilla/renderers/textile"
  end
end