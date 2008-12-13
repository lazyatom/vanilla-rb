$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'vanilla'

app = Vanilla::App.new(ENV['VANILLA_CONFIG'])
use Rack::Session::Cookie, :key => 'vanilla.session',
                           :path => '/',
                           :expire_after => 2592000,
			                     :secret => app.config[:secret]
use Rack::Static, :urls => ["/public"], :root => File.join(File.dirname(__FILE__))
run app