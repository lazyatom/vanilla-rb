require "test_helper"
require "tmpdir"

describe Vanilla::App do
  context "when behaving as a Rack application" do
    should "return a valid rack response" do
      create_snip(:name => "test", :content => "content")
      get "/test.text"
      assert_equal 200, last_response.status
      assert_kind_of Hash, last_response.headers
      assert_equal "content", last_response.body
    end
  end

  context "when being configured" do
    should "default the root snip to 'start'" do
      create_snip :name => "start", :content => "default"
      assert_response_body "default", "/"
    end

    should "allow a customised root snip" do
      create_snip :name => "start", :content => "default"
      create_snip :name => "custom", :content => "custom"
      app.config[:root_snip] = "custom"
      assert_response_body "custom", "/"
    end

    should "allow specification of the root directory to aide loading external soups" do
      soup_dir = File.join(Dir.tmpdir, "my_soup")
      FileUtils.mkdir_p(soup_dir)
      File.open(File.join(soup_dir, "blah.snip"), "w") { |f| f.write "Hello superfriends" }

      class TestApp < Vanilla::App
        configure do |c| 
          c.root = Dir.tmpdir
          c.soups = ["my_soup"]
        end
      end

      app = 
      assert_equal "Hello superfriends", TestApp.new.soup['blah'].content
    end

    should "allow configuration against the class" do
      class TestApp < Vanilla::App
      end

      TestApp.configure do |config|
        config.soups = ["blah", "monkey"]
        config.root = Dir.tmpdir
      end

      assert_equal ["blah", "monkey"], TestApp.new.config[:soups]
    end
  end

  context "when detecting the snip renderer" do
    should "return the constant refered to in the render_as property of the snip" do
      snip = create_snip(:name => "blah", :render_as => "Raw")
      assert_equal Vanilla::Renderers::Raw, app.renderer_for(snip)
    end

    context "using the snip extension" do
      {
        "markdown" => Vanilla::Renderers::Markdown,
        "textile" => Vanilla::Renderers::Textile,
        "erb" => Vanilla::Renderers::Erb,
        "rb" => Vanilla::Renderers::Ruby,
        "haml" => Vanilla::Renderers::Haml
      }.each do |extension, renderer|
        should "return the renderer #{renderer} when the snip has extension #{extension}" do
          snip = create_snip(:name => "blah", :extension => extension)
          assert_equal renderer, app.renderer_for(snip)
        end
      end
    end

    should "respect snip renderers passed in the config" do
      TestApp.configure do |c|
        c.renderers = {"markdown" => "Vanilla::Renderers::Bold"}
      end
      snip = create_snip(:name => "blah", :extension => "markdown")
      assert_equal Vanilla::Renderers::Bold, TestApp.new.renderer_for(snip)
    end

    should "return Vanilla::Renderers::Base if no render_as property exists" do
      snip = create_snip(:name => "blah")
      assert_equal Vanilla::Renderers::Base, app.renderer_for(snip)
    end

    should "return Vanilla::Renderers::Base if the render_as property is blank" do
      snip = create_snip(:name => "blah", :render_as => '')
      assert_equal Vanilla::Renderers::Base, app.renderer_for(snip)
    end

    should "raise an error if the specified renderer doesn't exist" do
      snip = create_snip(:name => "blah", :render_as => "NonExistentClass")
      assert_raises(NameError) { @app.renderer_for(snip) }
    end

    should "load constants presented as a string" do
      class ::MyRenderer
      end
      TestApp.configure do |c|
        c.renderers = {"my_renderer" => "MyRenderer"}
      end
      snip = create_snip(:name => "blah", :render_as => "my_renderer")
      assert_equal MyRenderer, TestApp.new.renderer_for(snip)
    end
  end
end