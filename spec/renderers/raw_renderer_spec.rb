require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Vanilla::Renderers::Raw, "when rendering" do
  before(:each) do
    @snip = create_snip(:name => "test", :content => "raw content", :part => "raw part")
    set_main_template "<tag>{current_snip}</tag>"
  end

  it "should render the contents part of the snip as it is" do
    response_body_for("/test.raw").should == "raw content"
  end
  
  it "should render the specified part of the snip" do
    response_body_for("/test/part.raw").should == "raw part"
  end
  
  it "should not perform any snip inclusion" do
    create_snip(:name => "snip_with_inclusions", :content => "loading {another_snip}")
    response_body_for("/snip_with_inclusions.raw").should == "loading {another_snip}"
  end
end