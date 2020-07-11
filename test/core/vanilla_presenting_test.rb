require "test_helper"

context "When presenting" do
  setup do
    set_main_template "<tag>{current_snip}</tag>"
    create_snip name: "test", content: "blah {other_snip}", part: 'part content'
    create_snip name: "other_snip", content: "blah!"
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
      assert_response_status 200, "/test"
      assert_response_status 200, "/test.html"
      assert_response_status 200, "/test/part"
      assert_response_status 200, "/test/part.html"
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
      assert_response_status 200, "/test.text"
      assert_response_status 200, "/test/part.text"
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
      assert_response_status 200, "/test.raw"
      assert_response_status 200, "/test/part.raw"
    end
  end

  context "the root URL" do
    should "render the start snip by default" do
      create_snip name: "start", content: "default"
      assert_response_body "<tag>default</tag>", "/"
    end

    should "render any custom-set root snip if provided" do
      create_snip name: "start", content: "default"
      create_snip name: "custom", content: "custom"
      app.config.root_snip = "custom"
      assert_response_body "<tag>custom</tag>", "/"
    end
  end

  context "a snip with a custom layout" do
    should "render the snips contents within that layout" do
      create_snip name: "custom-layout", content: "<custom>{current_snip}</custom>"
      create_snip name: "test", content: "this is a test", layout: "custom-layout"
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
      app.register_renderer CustomRenderer, "custom"
      create_snip name: "custom-layout", content: "<custom>{current_snip}</custom>"
    end

    should "use the renderer's specified layout" do
      create_snip name: "test", content: "this is a test", render_as: "custom"
      assert_response_body "<custom>this is a test</custom>", "/test"
    end

    should "use the snips layout when given" do
      create_snip name: "snip-custom-layout", content: "<snipcustom>{current_snip}</snipcustom>"
      create_snip name: "test", content: "this is a test", render_as: "custom", layout: "snip-custom-layout"
      assert_response_body "<snipcustom>this is a test</snipcustom>", "/test"
    end
  end

  context "and a custom default renderer has been provided" do
    should "use that renderer" do
      app.config.default_renderer = ::Vanilla::Renderers::Bold
      create_snip name: "layout", content: "{test}", render_as: "base"
      create_snip name: "test", content: "test"
      assert_response_body "<b>test</b>", "/test"
    end
  end

  context "and a missing snip is requested" do
    should "render missing snip content in the 404 template" do
      app.soup << {name: "404", content: "404 {current_snip}"}
      assert_response_body %{404 [snip 'missing_snip' cannot be found]}, "/missing_snip"
    end

    should "have a 404 response code" do
      assert_response_status 404, "/missing_snip"
    end
  end

  context "and a missing part of an existing snip is requested" do
    should "have a 404 response code" do
      create_snip name: "test", content: "this is a test"
      assert_response_status 404, "/test.missing_part"
    end
  end

  context "requesting an unknown format" do
    should "return a 404 status code" do
      assert_response_status 404, "/test.monkey"
    end
  end
end
