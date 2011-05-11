require "test_helper"

context "The raw dynasnip" do
  should "render the snip given in its raw form" do
    create_snip :name => "a", :content => "{b}"
    create_snip :name => "test", :content => "<div id='x'>{raw a}</div>"
    visit "/test"
    assert page.has_css?("#x", :content => "&#123;b&#125;")
  end

  should "escape html tags" do
    create_snip :name => "a", :content => "<b></b>"
    create_snip :name => "test", :content => "<div id='x'>{raw a}</div>"
    visit "/test"
    assert page.has_css?("#x", :content => "&lt;b&gt;&lt;/b&gt;")
  end

  should "render a raw part" do
    create_snip :name => "a", :content => "x", :bit => "a<b"
    create_snip :name => "test", :content => "<div id='x'>{raw a, bit}</div>"
    visit "/test"
    assert page.has_css?("#x", :content => "a&lt;b")
  end
end