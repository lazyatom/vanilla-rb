$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require "vanilla"
require "spec"
require "fileutils"

module Vanilla
  module Test
    def setup_clean_environment
      test_soup_config = { :database => File.join(File.dirname(__FILE__), "soup_test.db")}
      FileUtils.rm(test_soup_config[:database]) if File.exist?(test_soup_config[:database])
      Soup.base = test_soup_config

      # TODO: this is hard-coded for the AR implementation
      require "active_record"
      ActiveRecord::Migration.verbose = false
  
      Soup.prepare
      # load 'vanilla/snips/system.rb'
      require "vanilla/dynasnips/current_snip"
      CurrentSnip.persist!
      create_snip :name => "system", :main_template => "{current_snip}"
    end
    
    def response_for(url)
      Vanilla::App.new.call(mock_env_for_url(url))
    end
    
    def response_body_for(url)
      response_for(url)[2].body[0]
    end
    
    def response_code_for(url)
      response_for(url)[0]
    end
    
    def set_main_template(template_content)
      system = Vanilla.snip("system") || Snip.new(:name => "system")
      system.main_template = template_content
      system.save
    end
    
    extend self
  end
end

def create_snip(params)
  s = Snip.new(params)
  s.save
  s
end

require "rack/mock"

def mock_env_for_url(url)
  Rack::MockRequest.env_for(url)
end

def mock_request(url)
  Rack::Request.new(mock_env_for_url(url))
end