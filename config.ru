require 'rubygems'
require 'bundler/setup'
$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require 'vanilla'
require 'vanilla/static'

app = Vanilla::App.new(ENV['VANILLA_CONFIG'])
use Vanilla::Static, File.join(File.dirname(__FILE__), 'public')
run app
