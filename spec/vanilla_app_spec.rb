require File.join(File.dirname(__FILE__), 'spec_helper')

describe Vanilla::App do
  describe "when behaving as a Rack application" do
    it "should return an array of status code, headers and response" do
      create_snip(:name => "test", :content => "content")
      result = @app.call(mock_env_for_url("/test.text"))
      result.should be_a_kind_of(Array)
      result[0].should == 200
      result[1].should be_a_kind_of(Hash)
      result[2].each{ |output| output.should == "content" }
    end
  end
  
  describe "when being configured" do
    it "should load a config file from the current working directory by default" do
      File.should_receive(:open).with("config.yml").and_return(StringIO.new({:soup => soup_path}.to_yaml))
      Vanilla::App.new
    end
    
    it "should load a config file given" do
      File.open("/tmp/vanilla_config.yml", "w") { |f| f.write({:soup => soup_path, :hello => true}.to_yaml) }
      app = Vanilla::App.new("/tmp/vanilla_config.yml")
      app.config[:hello].should be_true
    end
    
    it "should allow saving of configuration to the same file it was loaded from" do
      config_file = "/tmp/vanilla_config.yml"
      File.open(config_file, "w") { |f| f.write({:soup => soup_path, :hello => true}.to_yaml) }
      app = Vanilla::App.new(config_file)
      app.config[:saved] = true
      app.config.save!
      
      config = YAML.load(File.open(config_file))
      config[:saved].should be_true
    end
  end
end