$LOAD_PATH.unshift(File.expand_path("../../../lib"), __FILE__)
require "kintama"
require "kintama/mocha"
require "vanilla/test_helper"

class TestApplication < Vanilla::App
end

module TestHelper
  include Vanilla::TestHelper

  def create_simple_layout
    require File.expand_path("../../../pristine_app/soups/system/current_snip", __FILE__)
    app.soup << CurrentSnip.snip_attributes
    create_snip name: "layout", content: "{current_snip}"
  end
end

Kintama.include TestHelper

Kintama.setup do
  vanilla_setup
  TestApplication.reset!
  create_simple_layout
end

Kintama.teardown do
  vanilla_teardown
end
