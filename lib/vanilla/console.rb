require 'vanilla'
require 'irb'

def app(reload=false)
  @__vanilla_console_app = nil if reload
  config = YAML.parse_file(ENV['VANILLA_CONFIG']) rescue {}
  @__vanilla_console_app ||= Vanilla::App.new(config)
end

puts "The Soup is simmering."