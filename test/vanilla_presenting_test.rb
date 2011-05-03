require "test_helper"

context "When presenting" do
  setup do
    set_main_template "<tag>{current_snip}</tag>"
    create_snip :name => "test", :content => "blah {other_snip}", :part => 'part content'
    create_snip :name => "other_snip", :content => "blah!"
  end

  context "HTML" do
    should "render the snip's content in the system template if no format or part is given" do
      assert_response_body "<tag>blah blah!</tag>", "/test"
    end

    should "render the snip's content in the system template if the HTML format is given" do
      assert_response_body "<tag>blah blah!</tag>", "/test.html"
    end

    should "render the requested part within the main template when a part is given" do
      assert_response_body "<tag>part content</tag>", "/test/part"
    end

    should "have a response code of 200" do
      assert_equal 200, response_code_for("/test")
      assert_equal 200, response_code_for("/test.html")
      assert_equal 200, response_code_for("/test/part")
      assert_equal 200, response_code_for("/test/part.html")
    end

    should "not allow rendering of the layout to produce infinite recursion" do
      assert_response_body "Rendering of the current layout would result in infinite recursion.", "/layout"
    end
  end

  context "as text" do
    should "render the snip's content outside of the main template with its default renderer" do
      assert_response_body "blah blah!", "/test.text"
    end

    should "render the snip part outside the main template when a format is given" do
      assert_response_body "part content", "/test/part.text"
    end

    should "have a response code of 200" do
      assert_equal 200, response_code_for("/test.text")
      assert_equal 200, response_code_for("/test/part.text")
    end
  end

  context "raw content" do
    should "render the snips contents exactly as they are" do
      assert_response_body "blah {other_snip}", "/test.raw"
    end

    should "render the snip content exactly even if a render_as attribute exists" do
      assert_response_body "CurrentSnip", "/current_snip.raw"
    end

    should "render a snips part if requested" do
      assert_response_body "part content", "/test/part.raw"
    end

    should "have a response code of 200" do
      assert_equal 200, response_code_for("/test.raw")
      assert_equal 200, response_code_for("/test/part.raw")
    end
  end

  context "a snip with a custom layout" do
    should "render the snips contents within that layout" do
      create_snip :name => "custom-layout", :content => "<custom>{current_snip}</custom>"
      create_snip :name => "test", :content => "this is a test", :layout => "custom-layout"
      assert_response_body "<custom>this is a test</custom>", "/test"
    end
  end

  class CustomRenderer < ::Vanilla::Renderers::Base
    def default_layout_snip
      soup['custom-layout']
    end
  end

  context "a snip using a renderer that specifies a template" do
    setup do
      @app.register_renderer CustomRenderer, "custom"
      create_snip :name => "custom-layout", :content => "<custom>{current_snip}</custom>"
    end

    should "use the renderer's specified layout" do
      create_snip :name => "test", :content => "this is a test", :render_as => "custom"
      assert_response_body "<custom>this is a test</custom>", "/test"
    end

    should "use the snips layout when given" do
      create_snip :name => "snip-custom-layout", :content => "<snipcustom>{current_snip}</snipcustom>"
      create_snip :name => "test", :content => "this is a test", :render_as => "custom", :layout => "snip-custom-layout"
      assert_response_body "<snipcustom>this is a test</snipcustom>", "/test"
    end
  end

  context "and a custom default renderer has been provided" do
    should "use that renderer" do
      @app = Vanilla::App.new(:soup => soup_path, :default_renderer => ::Vanilla::Renderers::Bold)
      require File.expand_path("../../pristine_app/soups/dynasnips/current_snip", __FILE__)
      @app.soup << CurrentSnip.snip_attributes
      create_snip :name => "layout", :content => "{current_snip}", :render_as => "base"
      create_snip :name => "test", :content => "test"
      assert_response_body "<b>test</b>", "/test"
    end
  end

  context "and a missing snip is requested" do
    should "render missing snip content in the main template" do
      assert_response_body %{<tag>Couldn't find snip "missing_snip"</tag>}, "/missing_snip"
    end

    should "have a 404 response code" do
      assert_equal 404, response_code_for("/missing_snip")
    end
  end

  context "requesting an unknown format" do
    should "return a 500 status code" do
      assert_equal 500, response_code_for("/test.monkey")
    end
  end
end
