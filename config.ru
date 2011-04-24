require 'rubygems'
require 'bundler/setup'
$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require 'vanilla'
require 'vanilla/static'

config = YAML.parse_file(ENV['VANILLA_CONFIG']) rescue {}
app = Vanilla::App.new(config)
use Vanilla::Static, File.join(File.dirname(__FILE__), 'public')
run app
