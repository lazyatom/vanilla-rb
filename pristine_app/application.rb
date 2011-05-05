$:.unshift File.expand_path("../lib", __FILE__)
require 'rubygems'
require 'bundler/setup'
require 'vanilla'

# This is your application subclass.
class Application < Vanilla::App
end

# This is where you can configure it.
Application.configure do |config|
  # You can partition your snips into subdirectories to keep things tidy. This
  # doesn't affect their URL structure on the site (everything is flat).
  config.soups = [
    "soups/base",
    "soups/system"
  ]
  # If you don't want the tutorial on your site, remove this and delete the directory
  config.soups << "soups/tutorial"

  # This is a dumping ground of ideas at the moment
  # config.soups << "soups/extras"
end