require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Vanilla::Renderers::Ruby do
  describe "when rendering normally" do
    class TestDyna < Dynasnip
      def handle(*args)
        'handle called'
      end
    end

    before(:each) do
      @app.soup << TestDyna.snip_attributes
    end
  
    it "should render the result of the handle method" do
      response_body_for("/test_dyna").should == 'handle called'
    end
  end

  describe "when responding restfully" do
    class RestishDyna < Dynasnip
      def get(*args)
        'get called'
      end
      def post(*args)
        'post called'
      end  
    end
    
    before(:each) do
      @app.soup << RestishDyna.snip_attributes
    end
  
    it "should render the result of the get method on GET requests" do
      response_body_for("/restish_dyna").should == 'get called'
    end
  
    it "should render the result of the post method on POST requests" do
      response_body_for("/restish_dyna?_method=post") == 'post called'
    end
  end
  
  describe "when knowing about enclosing snips" do
    class Encloser < Dynasnip
      def handle(*args)
        "enclosing snip is #{enclosing_snip.name}"
      end
    end
    
    before(:each) do
      @app.soup << Encloser.snip_attributes
      create_snip(:name => "test", :content => "{encloser}")
    end
    
    it "should know about the snip that called this dynasnip" do
      response_body_for("/test").should == 'enclosing snip is test'
    end
  end
end