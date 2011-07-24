module Vanilla
  VERSION = "1.17.1"

  autoload :Renderers, "vanilla/renderers"
  autoload :App, "vanilla/app"
  autoload :Config, "vanilla/config"
  autoload :Dynasnip, "vanilla/dynasnip"
  autoload :Request, "vanilla/request"
  autoload :Routing, "vanilla/routing"
  autoload :Static, "vanilla/static"
  autoload :SnipReferenceParser, "vanilla/snip_reference_parser"
  autoload :TestHelper, "vanilla/test_helper"

  class << self
    # The set of currently loaded Vanilla::App subclasses
    def apps
      @apps ||= []
    end
  end
end