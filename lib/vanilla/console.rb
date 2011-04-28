require 'vanilla'

def app(reload=false)
  if !@__vanilla_console_app || reload
    config = YAML.parse_file(ENV['VANILLA_CONFIG']) rescue {}
    @__vanilla_console_app = Vanilla::App.new(config)
  end
  @__vanilla_console_app
end