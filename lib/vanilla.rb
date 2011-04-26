module Vanilla
  VERSION = "1.14.1"

  autoload :Renderers, "vanilla/renderers"
  autoload :App, "vanilla/app"
  autoload :Dynasnip, "vanilla/dynasnip"
  autoload :Request, "vanilla/request"
  autoload :Routes, "vanilla/routes"
  autoload :Static, "vanilla/static"
end

# Load all the base dynasnip classes
Dir[File.join(File.dirname(__FILE__), 'vanilla', 'dynasnips', '*.rb')].each do |dynasnip|
  require dynasnip
end
