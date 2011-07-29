require "test_helper"
require "atom"

context "The feed dynasnip" do
  should "include snips" do
    stub_soup({:name => "Hello", :content => "This is the content"},
              {:name => "Goodbye", :content => "More content"})

    visit "/feed.xml"

    feed = Atom::Feed.load_feed(page.source)
    assert_equal 2, feed.entries.length
  end

  should "included rendered snip contents" do
    stub_soup({:name => "Hello", :content => "This is *the* content", :render_as => "markdown"})

    visit "/feed.xml"

    feed = Atom::Feed.load_feed(page.source)
    assert_equal "<p>This is <em>the</em> content</p>", feed.entries.first.content
  end

  private

  def stub_soup(*snips)
    app.soup.stubs(:all_snips).returns(snips.map { |s| snip({:created_at => Time.now}.merge(s)) })
  end

  def snip(attributes)
    Soup::Snip.new(attributes, nil)
  end
end