$LOAD_PATH.unshift File.join(File.dirname(__FILE__))
require 'vanilla/rack_app'

use Rack::Session::Cookie, :key => 'vanilla.session',
                           :path => '/',
                           :expire_after => 2592000
use Rack::Static, :urls => ["/public"], :root => "vanilla"
run Vanilla::RackApp.new