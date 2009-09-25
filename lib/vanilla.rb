require 'vanilla/app'

# Load all the other renderer subclasses
Dir[File.join(File.dirname(__FILE__), 'vanilla', 'renderers', '*.rb')].each { |f| require f }  

# Load all the base dynasnip classes
Dir[File.join(File.dirname(__FILE__), 'vanilla', 'dynasnips', '*.rb')].each do |dynasnip|
  require dynasnip
end
