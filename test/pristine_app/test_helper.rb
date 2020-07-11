$LOAD_PATH.unshift(File.expand_path("../../../lib"), __FILE__)
require "bundler/setup"
require "kintama"
require "kintama/mocha"
require "vanilla/test_helper"
require 'capybara'
require 'capybara/dsl'
require 'byebug'

require File.expand_path("../../../pristine_app/application", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../../pristine_app/soups", __FILE__)

module TestHelper
  include Vanilla::TestHelper
end

Kintama.include TestHelper
Kintama.include Capybara::DSL

Kintama.setup do
  Dir.chdir(File.expand_path("../../../pristine_app", __FILE__))
  vanilla_reset
  vanilla_setup
  Capybara.app = app
end

Kintama.teardown do
  vanilla_teardown
end
