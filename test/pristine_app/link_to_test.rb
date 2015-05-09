require "test_helper"

context "The link_to dynasnip" do
  should "render a link to the given snip using the snip name as text" do
    create_snip name: "test", content: "<div id='x'>this is a {link_to test}.</div>"
    visit "/test"
    assert page.find("#x a[href='/test']").has_content?('test')
  end

  should "render a link to the given snip using custom link text" do
    create_snip name: "test", content: "<div id='x'>this is a {link_to test, my link}.</div>"
    visit "/test"
    assert page.find("#x a[href='/test']").has_content?('my link')
  end

  should "render a link to the given snip and part" do
    create_snip name: "test", content: "<div id='x'>this is a {link_to test, test, part}.</div>"
    visit "/test"
    assert page.find("#x a[href='/test/part']").has_content?('test')
  end

  should "add a 'missing' class where the snip does not exist" do
    create_snip name: "test", content: "<div id='x'>this is a {link_to blah}.</div>"
    visit "/test"
    assert page.find("#x a.missing[href='/blah']")
  end
end
