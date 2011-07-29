require "test_helper"
require "atom"

context "An atom feed" do
  should "include snips" do
    stub_soup({:name => "Hello", :content => "This is the content"},
              {:name => "Goodbye", :content => "More content"})

    feed_xml = Vanilla::AtomFeed.new(:domain => "yourdomain.example.com", :app => app).to_s
    feed = Atom::Feed.load_feed(feed_xml)
    assert_equal 2, feed.entries.length
  end

  should "ensure that all links are made absolute" do
    stub_soup({:name => "alpha", :content => %|alpha <a href="/beta">beta</a>.|},
              {:name => "beta", :content => %|beta <a href='/alpha'>alpha</a>.|})

    assert get_feed.entries[0].content =~ %r{http://yourdomain\.example\.com/beta}, 
           "making double-quoted links external should work"
    assert get_feed.entries[1].content =~ %r{http://yourdomain\.example\.com/alpha},
           "making single-quoted links external should work"
  end

  should "allow inclusion of only specific snips" do
    snip_a_data = {:name => "a", :content => "x"}
    snip_b_data = {:name => "b", :content => "x"}
    stub_soup(snip_a_data, snip_b_data)
    
    feed_xml = app.atom_feed(:domain => "whatever", :snips => [snip(snip_a_data)]).to_s
    feed = Atom::Feed.load_feed(feed_xml)
    assert_equal 1, feed.entries.length
    assert_equal "a", feed.entries.first.title
  end

  should "set updated to be the latest updated_at of the included snips" do
    snip_a_data = {:name => "a", :content => "x", :updated_at => Time.parse("2011-05-22 12:00")}
    snip_b_data = {:name => "b", :content => "x", :updated_at => Time.parse("2011-05-23 12:34")}
    snip_c_data = {:name => "c", :content => "x", :updated_at => Time.parse("2011-05-24 12:34")}
    stub_soup(snip_a_data, snip_b_data, snip_c_data)
    
    feed_xml = app.atom_feed(:domain => "whatever", :snips => [snip(snip_a_data), snip(snip_b_data)]).to_s
    feed = Atom::Feed.load_feed(feed_xml)
    assert_equal Time.parse("2011-05-23 12:34"), feed.updated
  end

  context "title" do
    setup do
      stub_soup
    end

    should "be settable via the initialiser" do
      feed_xml = app.atom_feed(:domain => "yourdomain.example.com", :title => "My Title").to_s
      feed = Atom::Feed.load_feed(feed_xml)
      assert_equal "My Title", feed.title
    end

    should "default to the domain" do
      feed_xml = app.atom_feed(:domain => "yourdomain.example.com").to_s
      feed = Atom::Feed.load_feed(feed_xml)
      assert_equal "yourdomain.example.com", feed.title
    end
  end

  context "entry" do
    setup do
      stub_soup({:name => "Hello", :content => "The *content*", 
                 :render_as => "markdown", :created_at => Time.parse("2011-01-01 12:23").to_s})
    end

    context "titles" do
      should "default to be the name of the snip" do
        assert_equal "Hello", get_feed.entries.first.title
      end

      should "use the title of the snip if present" do
        stub_soup({:name => "hello-mammy", :content => "x", :title => "Hello, Mammy"})
        assert_equal "Hello, Mammy", get_feed.entries.first.title
      end
    end

    context "authors" do
      should "set the author to be the domain by default" do
        assert_equal ["yourdomain.example.com"], get_feed.entries.first.authors.map { |a| a.name }
      end

      should "set the authors if the snip provides" do
        stub_soup({:name => "a", :content => "x", :author => "james"})
        assert_equal ["james"], get_feed.entries.first.authors.map { |a| a.name }
      end
    end

    should "included rendered snip contents" do
      assert_equal "<p>The <em>content</em></p>", get_feed.entries.first.content
    end


    should "include a link to the snip" do
      assert_equal ["http://yourdomain.example.com/Hello"], get_feed.entries.first.links.map { |l| l.href }
    end

    should "set the ID based on the domain, timestamp and snip name" do
      assert_equal "tag:yourdomain.example.com,2011-01-01:/Hello", get_feed.entries.first.id
    end

    should "set the published date based on the snip created_at date" do
      assert_equal Time.parse("2011-01-01 12:23"), get_feed.entries.first.published
    end

    context "updated at" do
      should "default to the published date" do
        assert_equal Time.parse("2011-01-01 12:23"), get_feed.entries.first.updated
      end

      should "set the updated at to the snip attribute if it exists" do
        stub_soup({:name => "Hello", :content => "the content", :updated_at => Time.parse("2011-01-02 13:45").to_s})
        assert_equal Time.parse("2011-01-02 13:45"), get_feed.entries.first.updated
      end
    end
  end

  private

  def get_feed
    feed_xml = app.atom_feed(:domain => "yourdomain.example.com").to_s
    Atom::Feed.load_feed(feed_xml)
  end

  def stub_soup(*snips)
    app.soup.stubs(:all_snips).returns(snips.map { |s| snip({:created_at => Time.now}.merge(s)) })
  end

  def snip(attributes)
    Soup::Snip.new(attributes, nil)
  end
end