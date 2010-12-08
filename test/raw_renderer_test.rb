require "test_helper"

describe Vanilla::Renderers::Raw do
  context "when rendering" do
    setup do
      @snip = create_snip(:name => "test", :content => "raw content", :part => "raw part")
      set_main_template "<tag>{current_snip}</tag>"
    end

    should "render the contents part of the snip as it is" do
      assert_response_body "raw content", "/test.raw"
    end
  
    should "render the specified part of the snip" do
      assert_response_body "raw part", "/test/part.raw"
    end
  
    should "not perform any snip inclusion" do
      create_snip(:name => "snip_with_inclusions", :content => "loading {another_snip}")
      assert_response_body "loading {another_snip}", "/snip_with_inclusions.raw"
    end
  end
end