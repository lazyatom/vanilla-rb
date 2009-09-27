require 'vanilla'
require 'irb'

def app(reload=false)
  @__vanilla_console_app = nil if reload
  @__vanilla_console_app ||= Vanilla::App.new(ENV['VANILLA_CONFIG'])
end

puts "The Soup is simmering."