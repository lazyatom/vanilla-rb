require "test_helper"

context "When including snips in other snips" do
  setup do
    create_snip :name => "test", :content => "snip content"
  end

  should "match simple snips" do
    assert_equal "rendering snip content", render("rendering {test}")
  end

  should "match snips with an argument" do
    assert_equal "rendering snip content", render("rendering {test arg1}")
  end

  should "match snips with several arguments" do
    assert_equal "rendering snip content", render("rendering {test arg1, arg2}")
  end

  should "match snips with hyphens" do
    create_snip :name => "test-snip", :content => "snip content"
    assert_equal "rendering snip content", render("rendering {test-snip}")
  end

  should "match snips with underscores" do
    create_snip :name => "test_snip", :content => "snip content"
    assert_equal "rendering snip content", render("rendering {test_snip}")
  end

  should "match snips with numbers" do
    create_snip :name => "test1", :content => "snip content"
    assert_equal "rendering snip content", render("rendering {test1}")
  end

  should "match snips with ruby 1.9 style hashes" do
    create_snip :name => "test", :content => %{
      class Blah
        def handle(args)
          args.inspect
        end
        self
      end
    }, :render_as => "Ruby"
    assert_equal %{rendering {:x=>"1"}}, render("rendering {test x:1}")
  end

  should "ignore references that are rubyish" do
    assert_equal "10.times { |x| puts x }", render("10.times { |x| puts x }")
    assert_equal "10.times {|x| puts x }", render("10.times {|x| puts x }")
  end

  should "ignore references that contain newlines" do
    assert_equal "{\nnot a dyna\n}", render("{\nnot a dyna\n}")
  end

  should "render malformed snip inclusions for easier debugging" do
    assert_equal %|this is a <span class="malformed_snip_inclusion">(malformed snip inclusion: &#123;link_to blah blah&#125;)</span>|,
      render("this is a {link_to blah blah}")
  end

  def render(content)
    snip = create_snip :name => "test-content", :content => content
    Vanilla::Renderers::Base.new(@app).render(snip)
  end
end