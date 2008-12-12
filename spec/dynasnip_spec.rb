require File.join(File.dirname(__FILE__), "spec_helper")
require 'vanilla/dynasnip'

describe Dynasnip, "when storing attributes" do
  class TestDyna < Dynasnip
    attribute :test_attribute, "test attribute content"
  end
  
  before(:each) do
    @fake_app = nil
  end
  
  it "should make the attribute available as an instance method" do
    TestDyna.new(@fake_app).test_attribute.should == "test attribute content"
  end

  it "should store the attribute in the soup" do
    TestDyna.persist!
    Soup['test_dyna'].test_attribute.should == "test attribute content"
  end
  
  it "should allow the attribute to be overriden by the soup contents" do
    TestDyna.persist!
    snip = Soup['test_dyna']
    snip.test_attribute = "altered content"
    snip.save
    
    TestDyna.new(@fake_app).test_attribute.should == "altered content"
  end
  
end