unless File.exist?("application.rb")
  puts "Your application must reside in application.rb to use this console"
  exit -1
end

def app(reload=false)
  if !@__vanilla_console_app || reload
    load "application.rb"
    @__vanilla_console_app = Vanilla.apps.first.new
  end
  @__vanilla_console_app
end