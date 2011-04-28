require 'rubygems'
require 'bundler/setup'
$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require 'vanilla'

# You can partition your snips into subdirectories to keep things tidy. This
# doesn't affect their URL structure on the site (everything is flat).
soups = [
  "soups/base",
  "soups/dynasnips"
]

# If you don't want the tutorial on your site, remove this and delete the directory
soups << "soups/tutorial"

# This is a dumping ground of ideas at the moment
# soups << "soups/extras"

app = Vanilla::App.new(:soups => soups)

# If you running your site under a proper webserver, you probably don't need this.
require 'vanilla/static'
use Vanilla::Static, File.join(File.dirname(__FILE__), 'public')

run app
