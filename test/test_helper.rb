require 'rubygems'
require 'bundler/setup'
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "kintama"
require "kintama/mocha"
require "fileutils"
require "rack/mock"
require "vanilla"

module Vanilla
  module Test
    def setup_clean_environment
      clean_environment
      @app = Vanilla::App.new(:soup => soup_path)

      require File.expand_path("../../pristine_app/soups/system/current_snip", __FILE__)
      @app.soup << CurrentSnip.snip_attributes
      create_snip :name => "layout", :content => "{current_snip}"
    end

    def response_for(url)
      @app.call(mock_env_for_url(url))
    end

    def response_body_for(url)
      response_for(url)[2].body[0]
    end

    def response_code_for(url)
      response_for(url)[0]
    end

    def assert_response_body(expected, uri)
      assert_equal expected.strip, response_body_for(uri).strip
    end

    def set_main_template(template_content)
      @app.soup << {:name => "layout", :content => template_content}
    end

    def create_snip(params)
      @app.soup << params
    end

    def mock_env_for_url(url)
      Rack::MockRequest.env_for(url)
    end

    def mock_request(url)
      Rack::Request.new(mock_env_for_url(url))
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