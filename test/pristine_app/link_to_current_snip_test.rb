require "test_helper"

context "The link_to_current_snip dynasnip" do
  should "create a link to the snip that was requested" do
    create_snip name: "a", content: "{b}"
    create_snip name: "b", content: "<div id='x'>{link_to_current_snip}</div>"

    visit "/a"
    assert page.has_css?("#x a[href='/a']")
  end
end
