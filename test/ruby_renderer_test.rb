require "test_helper"

class RubyRendererTest < Vanilla::TestCase
  context "when rendering normally" do
    class ::TestDyna < Dynasnip
      def handle(*args)
        'handle called'
      end
    end

    setup do
      @app.soup << TestDyna.snip_attributes
    end
  
    should "render the result of the handle method" do
      assert_response_body 'handle called', "/test_dyna"
    end
  end

  context "when responding restfully" do
    class ::RestishDyna < Dynasnip
      def get(*args)
        'get called'
      end
      def post(*args)
        'post called'
      end  
    end
    
    setup do
      @app.soup << RestishDyna.snip_attributes
    end
  
    should "render the result of the get method on GET requests" do
      assert_response_body 'get called', "/restish_dyna"
    end
  
    should "render the result of the post method on POST requests" do
      assert_response_body 'post called', "/restish_dyna?_method=post"
    end
  end
  
  context "when knowing about enclosing snips" do
    class ::Encloser < Dynasnip
      def handle(*args)
        "enclosing snip is #{enclosing_snip.name}"
      end
    end
    
    setup do
      @app.soup << Encloser.snip_attributes
      create_snip(:name => "test", :content => "{encloser}")
    end
    
    should "know about the snip that called this dynasnip" do
      assert_response_body 'enclosing snip is test', "/test"
    end
  end
end