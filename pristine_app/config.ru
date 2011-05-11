# If you're running your site under a proper webserver, you probably don't need this.
require 'vanilla/static'
use Vanilla::Static, File.join(File.dirname(__FILE__), 'public')

require "application"
run PristineApplication.new