require File.join(File.dirname(__FILE__), "spec_helper")

describe Vanilla::App do  
  before(:each) do
    LinkTo.persist!
    set_main_template "<tag>{current_snip}</tag>"
    create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
    create_snip :name => "other_snip", :content => "blah!"
  end
  
  describe "when presenting as HTML" do
    it "should render the snip's content in the system template if no format or part is given" do
      response_body_for("/test").should == "<tag>blah blah!</tag>"
    end
  
    it "should render the snip's content in the system template if the HTML format is given" do
      response_body_for("/test.html").should == "<tag>blah blah!</tag>"
    end
  
    it "should render the requested part within the main template when a part is given" do
      response_body_for("/test/part").should == "<tag>part content</tag>"
    end
    
    it "should have a response code of 200" do
      response_code_for("/test").should == 200
      response_code_for("/test.html").should == 200
      response_code_for("/test/part").should == 200
      response_code_for("/test/part.html").should == 200
    end
  end

  describe "when presenting content as text" do
    it "should render the snip's content outside of the main template with its default renderer" do
      response_body_for("/test.text").should == "blah blah!"
    end
  
    it "should render the snip part outside the main template when a format is given" do
      response_body_for("/test/part.text").should == "part content"
    end
    
    it "should have a response code of 200" do
      response_code_for("/test.text").should == 200
      response_code_for("/test/part.text").should == 200
    end
  end


  describe "when presenting raw content" do
    it "should render the snips contents exactly as they are" do
      response_body_for("/test.raw").should == "blah {other_snip}"
    end
  
    it "should render the snip content exactly even if a render_as attribute exists" do
      response_body_for("/current_snip.raw").should == "CurrentSnip"
    end
  
    it "should render a snips part if requested" do
      response_body_for("/test/part.raw").should == "part content"
    end
    
    it "should have a response code of 200" do
      response_code_for("/test.raw").should == 200
      response_code_for("/test/part.raw").should == 200
    end
  end
  
  
  describe "when a missing snip is requested" do
    it "should render missing snip content in the main template" do
      response_body_for("/missing_snip").should == "<tag>Couldn't find snip #{LinkTo.new(nil).handle("missing_snip")}</tag>"
    end
    
    it "should have a 404 response code" do
      response_code_for("/missing_snip").should == 404
    end
  end
  
  
  describe "when requesting an unknown format" do
    it "should return a 500 status code" do
      response_code_for("/test.monkey").should == 500
    end  
  end
end