require 'vanilla'

module Vanilla
  class RackShim
    def run(app)
      app # return it
    end
    def use(*args)
      # ignore
    end
    def get_binding
      binding
    end
  end
end

def app(reload=false)
  if !@__vanilla_console_app || reload
    shim_binding = Vanilla::RackShim.new.get_binding
    @__vanilla_console_app = eval File.read("config.ru"), shim_binding
  end
  @__vanilla_console_app
end