require "test_helper"

context "The page_title dynasnip" do
  should "render as the requested snip name if that snip has no title" do
    visit "/"
    assert page.has_css?("head title", :content => "start"), page.source
  end

  should "render as the requested snip's page_title when that attribute is present" do
    create_snip :name => "test", :content => "test", :page_title => "This is a test"

    visit "/test"
    assert page.has_css?("head title", :content => "This is a test")
  end
end