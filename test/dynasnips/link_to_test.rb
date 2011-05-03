require "test_helper"
$LOAD_PATH.unshift File.expand_path("../../../pristine_app/soups/system", __FILE__)
require "link_to"

context "The link_to dynasnip" do
  setup do
    create_snip :name => "start", :content => "hello"
  end

  should "render a link to a snip that exists" do
    assert_equal %{<a href="/start">start</a>}, render_dynasnip(LinkTo, "start")
  end

  should "allow specification of the link text" do
    assert_equal %{<a href="/start">the start snip</a>}, render_dynasnip(LinkTo, "start", "the start snip")
  end

  should "mark snips that are missing with a class" do
    assert_equal %{<a class="missing" href="/missing">missing</a>}, render_dynasnip(LinkTo, "missing")
  end

  private

  def render_dynasnip(klass, *args)
    klass.new(@app).handle(*args)
  end
end