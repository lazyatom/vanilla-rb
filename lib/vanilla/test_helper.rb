require "vanilla"
require "rack/test"
require "tmpdir"
require "fileutils"

module Vanilla
  module TestHelper
    include Rack::Test::Methods

    def app
      unless @__app
        Application.configure do |config|
          # inject a sandbox soup path first.
          config.soups ||= []
          config.soups.unshift test_soup_path
          # Ensure that the root path is set; this helps with
          # running tests from different directories
          config.root_path = File.expand_path("../.", __FILE__)
        end
        @__app = Application.new
      end
      @__app
    end

    def vanilla_setup
      FileUtils.mkdir_p(test_soup_path)
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

    def test_soup_path
      File.expand_path(File.join(Dir.tmpdir, "soup"))
    end

    def vanilla_teardown
      FileUtils.rm_rf(test_soup_path)
    end
  end
end