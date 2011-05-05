require "kintama"
require "kintama/mocha"
require "fileutils"
require "rack/mock"
require "vanilla"
require "rack/test"

module Vanilla
  module Test
    include Rack::Test::Methods

    class ::TestApp < Vanilla::App
    end

    def app
      @__app ||= TestApp.new(:soup => soup_path)
    end

    def setup_clean_environment
      clean_environment
      TestApp.reset!

      require File.expand_path("../../pristine_app/soups/system/current_snip", __FILE__)
      app.soup << CurrentSnip.snip_attributes
      create_snip :name => "layout", :content => "{current_snip}"
    end

    def assert_response_status(expected, uri)
      get uri
      assert_equal expected, last_response.status
    end

    def assert_response_body(expected, uri)
      get uri
      assert_equal expected.strip, last_response.body.strip
    end

    def set_main_template(template_content)
      app.soup << {:name => "layout", :content => template_content}
    end

    def create_snip(params)
      app.soup << params
    end

    def test_app_directory
      File.join(File.dirname(__FILE__), "tmp")
    end

    def soup_path
      File.expand_path(File.join(test_app_directory, "soup"))
    end

    def clean_environment
      FileUtils.rm_rf(test_app_directory)
    end
  end
end

Kintama.include Vanilla::Test

Kintama.setup do
  setup_clean_environment
end

Kintama.teardown do
  clean_environment
end