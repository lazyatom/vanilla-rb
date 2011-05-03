require "test_helper"
$LOAD_PATH.unshift File.expand_path("../../../pristine_app/soups/dynasnips", __FILE__)
require "page_title"

context "The page_title dynasnip" do
  setup do
    @app.soup << PageTitle.snip_attributes
  end

  should "render as the requested snip name if that snip has no title" do
    create_snip :name => "test", :content => "{page_title}"
    assert_response_body %{test}, "/test"
  end

  should "render as the requested snip's page_title when that attribute is present" do
    create_snip :name => "test", :content => "{page_title}", :page_title => "This is a test"
    assert_response_body %{This is a test}, "/test"
  end
end