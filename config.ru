$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'vanilla'

use Rack::Session::Cookie, :key => 'vanilla.session',
                           :path => '/',
                           :expire_after => 2592000,
			   :secret => YAML.load(File.read(File.join(Vanilla::App.root,'config','secret.yml')))['secret']
use Rack::Static, :urls => ["/public"], :root => File.join(File.dirname(__FILE__), *%w[vanilla])
run Vanilla::App.new(ENV['VANILLA_CONFIG'])