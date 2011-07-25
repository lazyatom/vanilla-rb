require "test_helper"

context "The index dynasnip" do
  should "render links to every snip with the most recently updated first" do
    app.soup.stubs(:all_snips).returns([
      snip(:name => "alpha", :updated_at => Time.at(10)),
      snip(:name => "beta", :updated_at => Time.at(20)),
      snip(:name => "gamma", :updated_at => Time.at(40)),
      snip(:name => "delta", :updated_at => Time.at(30))
    ])

    visit "/index"
    links = page.all("ol#index li a").map { |l| l.text }
    assert_equal %w(gamma delta beta alpha), links
  end

  should "order snips without updated_at as if they were updated a long time ago" do
    app.soup.stubs(:all_snips).returns([
      snip(:name => "alpha", :updated_at => Time.at(10)),
      snip(:name => "beta", :updated_at => Time.at(20)),
      snip(:name => "gamma")
    ])

    visit "/index"
    links = page.all("ol#index li a").map { |l| l.text }
    assert_equal %w(beta alpha gamma), links
  end

  should "render links to snips with weird characters and spaces" do
    app.soup.stubs(:all_snips).returns([
      snip(:name => "fun fun", :updated_at => Time.at(20))
    ])

    visit "/index"
    links = page.all("ol#index li a").map { |l| l.text }
    assert_equal ["fun fun"], links
  end

  private

  def snip(attributes)
    Soup::Snip.new(attributes, nil)
  end
end