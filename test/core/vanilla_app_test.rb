require "test_helper"
require "tmpdir"

describe Vanilla::App do
  context "when behaving as a Rack application" do
    should "return a valid rack response" do
      create_snip(:name => "test", :content => "content")
      get "/test.text"
      assert_equal 200, last_response.status
      assert_kind_of Hash, last_response.headers
      assert_equal "content", last_response.body
    end

    should "return an empty body for HEAD request" do
      create_snip(:name => "test", :content => "content")
      head "/test.text"
      assert_equal 200, last_response.status
      assert_kind_of Hash, last_response.headers
      assert last_response.body.empty?
    end
  end

  context "when detecting the snip renderer" do
    should "return the constant refered to in the render_as property of the snip" do
      snip = create_snip(:name => "blah", :render_as => "Raw")
      assert_equal Vanilla::Renderers::Raw, app.renderer_for(snip)
    end

    context "using the snip extension" do
      {
        "markdown" => Vanilla::Renderers::Markdown,
        "textile" => Vanilla::Renderers::Textile,
        "erb" => Vanilla::Renderers::Erb,
        "rb" => Vanilla::Renderers::Ruby,
        "haml" => Vanilla::Renderers::Haml
      }.each do |extension, renderer|
        should "return the renderer #{renderer} when the snip has extension #{extension}" do
          snip = create_snip(:name => "blah", :extension => extension)
          assert_equal renderer, app.renderer_for(snip)
        end
      end
    end

    should "return Vanilla::Renderers::Base if no render_as property exists" do
      snip = create_snip(:name => "blah")
      assert_equal Vanilla::Renderers::Base, app.renderer_for(snip)
    end

    should "return Vanilla::Renderers::Base if the render_as property is blank" do
      snip = create_snip(:name => "blah", :render_as => '')
      assert_equal Vanilla::Renderers::Base, app.renderer_for(snip)
    end

    should "raise an error if the specified renderer doesn't exist" do
      snip = create_snip(:name => "blah", :render_as => "NonExistentClass")
      assert_raises(Vanilla::MissingRendererError) { app.renderer_for(snip) }
    end
  end
end
