require "test_helper"
require "atom"
require "base/feed"

context "The feed dynasnip" do
  should "include snips of the specified kind" do
     stub_app_soup({:name => "Hello", :content => "This is the content", :kind => "blog"},
                   {:name => "Goodbye", :content => "More content", :kind => "blog"},
                   {:name => "system", :content => "not to be shown"},
                   Feed.snip_attributes)

    visit "/feed.xml"

    feed = Atom::Feed.load_feed(page.source)
    assert_equal 2, feed.entries.length
  end

  should "included rendered snip contents" do
     stub_app_soup({:name => "Hello", :content => "This is *the* content",
                    :render_as => "markdown", :kind => "blog"},
                    Feed.snip_attributes)

    visit "/feed.xml"

    feed = Atom::Feed.load_feed(page.source)
    assert_equal "<p>This is <em>the</em> content</p>", feed.entries.first.content
  end
end