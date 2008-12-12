require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Vanilla::Renderers::Ruby do
  describe "when rendering normally" do
    class TestDyna < Dynasnip
      def handle(*args)
        'handle called'
      end
    end

    before(:each) do
      @test_dyna = TestDyna.persist!
    end
  
    it "should render the result of the handle method" do
      Vanilla::Test.response_body_for("/test_dyna").should == 'handle called'
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
      @dyna = RestishDyna.persist!
    end
  
    it "should render the result of the get method on GET requests" do
      Vanilla::Test.response_body_for("/restish_dyna").should == 'get called'
    end
  
    it "should render the result of the post method on POST requests" do
      Vanilla::Test.response_body_for("/restish_dyna?_method=post") == 'post called'
    end
  end
end