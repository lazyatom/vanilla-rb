require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe "when detecting the snip renderer" do
  before(:each) do
    @app = Vanilla::App.new
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