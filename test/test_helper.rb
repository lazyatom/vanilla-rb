require "shoulda"
require "mocha"
require "fileutils"
require "rack/mock"
require "vanilla"

module Vanilla
  module Test
    def setup_clean_environment
      FileUtils.mkdir_p(File.dirname(test_config_file))
      clear_soup
      File.open(test_config_file, 'w') { |f| f.write({:soup => soup_path}.to_yaml) }
      @app = Vanilla::App.new(test_config_file)

      require "vanilla/dynasnips/current_snip"
      @app.soup << CurrentSnip.snip_attributes
      create_snip :name => "system", :main_template => "{current_snip}"
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
      assert_equal expected, response_body_for(uri)
    end

    def set_main_template(template_content)
      system = @app.soup["system"] || Snip.new({:name => "system"}, @app.soup)
      system.main_template = template_content
      system.save
    end

    def create_snip(params)
      s = Snip.new(params, @app.soup)
      s.save
      s
    end

    def mock_env_for_url(url)
      Rack::MockRequest.env_for(url)
    end

    def mock_request(url)
      Rack::Request.new(mock_env_for_url(url))
    end

    def test_config_file
      File.join(File.dirname(__FILE__), "tmp", "config.yml")
    end

    def test_config(options={})
      File.open(test_config_file, 'w') { |f| f.write({:soup => soup_path}.update(options).to_yaml) }
    end

    def soup_path
      File.expand_path(File.join(File.dirname(__FILE__), "tmp", "soup"))
    end

    def clear_soup
      FileUtils.rm_rf(soup_path)
    end
  end
end

class Vanilla::TestCase < Test::Unit::TestCase
  include Vanilla::Test

  def setup
    setup_clean_environment
  end
end
