require File.join(File.dirname(__FILE__), "spec_helper")
require 'vanilla/dynasnip'

describe Dynasnip, "when storing attributes" do
  class TestDyna < Dynasnip
    attribute :test_attribute, "test attribute content"
  end
  
  it "should make the attribute available as an instance method" do
    p TestDyna.new(@app).test_attribute
    TestDyna.new(@app).test_attribute.should == "test attribute content"
  end

  it "should store the attribute in the soup" do
    @app.soup << TestDyna.snip_attributes
    @app.soup['test_dyna'].test_attribute.should == "test attribute content"
  end
  
  it "should allow the attribute to be overriden by the soup contents" do
    @app.soup << TestDyna.snip_attributes
    snip = @app.soup['test_dyna']
    snip.test_attribute = "altered content"
    snip.save
    
    TestDyna.new(@app).test_attribute.should == "altered content"
  end
  
end