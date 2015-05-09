require "test_helper"

context "The raw dynasnip" do
  should "render the snip given in its raw form" do
    create_snip name: "a", content: "{b}"
    create_snip name: "test", content: "<div id='x'>{raw a}</div>"
    visit "/test"
    assert page.source.include?("<div id='x'>&#123;b&#125;</div>")
  end

  should "escape html tags" do
    create_snip name: "a", content: "<b></b>"
    create_snip name: "test", content: "<div id='x'>{raw a}</div>"
    visit "/test"
    assert page.source.include?("<div id='x'>&lt;b&gt;&lt;/b&gt;</div>")
  end

  should "render a raw part" do
    create_snip name: "a", content: "x", bit: "a<b"
    create_snip name: "test", content: "<div id='x'>{raw a, bit}</div>"
    visit "/test"
    assert page.source.include?("<div id='x'>a&lt;b</div>")
  end
end
