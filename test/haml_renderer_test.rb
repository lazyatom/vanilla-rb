require 'haml'
require 'test_helper'

class HamlRendererTest < Vanilla::TestCase
  context "when rendering" do
    should "render Haml into HTML" do
      haml_snip(:name => "test", :content => "#hello\n  stuff")
      assert_response_body %{<div id='hello'>\n  stuff\n</div>}, "/test"
    end

    should "insert evaluated Haml content into the snip" do
      haml_snip(:name => "test", :content => "= 1 + 2")
      assert_response_body "3", "/test"
    end

    should "evaluate Erb content in the snip" do
      haml_snip(:name => "test", :content => "- if false\n  monkey\n- else\n  donkey")
      assert_response_body "donkey", "/test"
    end

    should "expose the snip as an instance variable" do
      haml_snip(:name => "test", :content => "= @snip.name")
      assert_response_body "test", "/test"
    end

    should "expose the app as an instance variable" do
      haml_snip(:name => "test", :content => "= @app.class.name")
      assert_response_body "Vanilla::App", "/test"
    end
  end

  private

  def haml_snip(params)
    create_snip(params.merge(:render_as => "Haml"))
  end
end