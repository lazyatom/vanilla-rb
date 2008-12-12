require File.join(File.dirname(__FILE__), 'spec_helper')

describe Vanilla::App do  
  it "should return an array of status code, headers and response" do
    create_snip(:name => "test", :content => "content")
    result = Vanilla::App.new.call(mock_env_for_url("/test.text"))
    result.should be_a_kind_of(Array)
    result[0].should == 200
    result[2].each{ |output| output.should == "content" }
  end
end