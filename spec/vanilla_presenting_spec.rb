require "spec_helper"
require "vanilla/app"

describe Vanilla::App do
  
  describe "when detecting the snip renderer" do
    before(:each) do
      Vanilla::Test.setup_clean_environment
      @app = Vanilla::App.new(nil)
    end

    it "should return the constant refered to in the render_as property of the snip" do
      snip = create_snip(:render_as => "Raw")
      @app.renderer_for(snip).should == Vanilla::Renderers::Raw
    end
  
    it "should return Vanilla::Renderers::Base if no render_as property exists" do
      snip = create_snip(:name => "blah")
      @app.renderer_for(snip).should == Vanilla::Renderers::Base
    end
  
    it "should return Vanilla::Renderers::Base if the render_as property is blank" do
      snip = create_snip(:name => "blah", :render_as => '')
      @app.renderer_for(snip).should == Vanilla::Renderers::Base
    end
  
    it "should raise an error if the specified renderer doesn't exist" do
      snip = create_snip(:render_as => "NonExistentClass")
      lambda { @app.renderer_for(snip) }.should raise_error
    end
  
    it "should load constants outside of the Vanilla::Renderers module" do
      class ::MyRenderer
      end
    
      snip = create_snip(:render_as => "MyRenderer")
      @app.renderer_for(snip).should == MyRenderer      
    end
  end

  module VanillaResponseSpecHelper
    def response_for(request)
      Vanilla::App.new(mock_request(request)).present
    end
    def response_body_for(request)
      response_for(request)[2].body[0]
    end
  end

  describe "when presenting as HTML" do
    include VanillaResponseSpecHelper
  
    before(:each) do 
      Vanilla::Test.setup_clean_environment
      create_snip :name => "system", :main_template => "<tag>{current_snip}</tag>"
      create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
      create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
      create_snip :name => "other_snip", :content => "blah!"
    end
  
    it "should render the snip's content in the system template if no format or part is given" do
      response_body_for("/test").should == "<tag>blah blah!</tag>"
    end
  
    it "should render the snip's content in the system template if the HTML format is given" do
      response_body_for("/test.html").should == "<tag>blah blah!</tag>"
    end
  
    it "should render the requested part within the main template when a part is given" do
      response_body_for("/test/part").should == "<tag>part content</tag>"
    end
  end

  describe "when presenting content as text" do
    include VanillaResponseSpecHelper
  
    before(:each) do 
      Vanilla::Test.setup_clean_environment
      create_snip :name => "system", :main_template => "<tag>{current_snip}</tag>"
      create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
      create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
      create_snip :name => "other_snip", :content => "blah!"
    end
  
    it "should render the snip's content outside of the main template with its default renderer" do
      response_body_for("/test.text").should == "blah blah!"
    end
  
    it "should render the snip part outside the main template when a format is given" do
      response_body_for("/test/part.text").should == "part content"
    end
  end


  describe "when presenting raw content" do
    include VanillaResponseSpecHelper
  
    before(:each) do 
      Vanilla::Test.setup_clean_environment
      create_snip :name => "system", :main_template => "<tag>{current_snip}</tag>"
      create_snip :name => "current_snip", :content => "CurrentSnip", :render_as => "Ruby"
      create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
      create_snip :name => "other_snip", :content => "blah!"
    end
  
    it "should render the snips contents exactly as they are" do
      response_body_for("/test.raw").should == "blah {other_snip}"
    end
  
    it "should render the snip content exactly even if a render_as attribute exists" do
      response_body_for("/current_snip.raw").should == "CurrentSnip"
    end
  
    it "should render a snips part if requested" do
      response_body_for("/test/part.raw").should == "part content"
    end
  end
end