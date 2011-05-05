require "test_helper"
$LOAD_PATH.unshift File.expand_path("../../../pristine_app/soups/system", __FILE__)
require "link_to_current_snip"

context "The link_to_current_snip dynasnip" do
  setup do
    app.soup << LinkToCurrentSnip.snip_attributes
    create_snip :name => "test", :content => "test {link_to_current_snip}"
  end

  should "render a link to the snip that was requested" do
    assert_response_body %{test <a href="/test">test</a>}, "/test"
  end

  should "render a link to the snip that was requested even if it isn't the snip that included the dyna" do
    create_snip :name => "othertest", :content => "othertest {test}"
    assert_response_body %{othertest test <a href="/othertest">othertest</a>}, "/othertest"
  end
end