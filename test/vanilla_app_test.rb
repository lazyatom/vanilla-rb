require "test_helper"
require "tmpdir"

describe Vanilla::App do
  context "when behaving as a Rack application" do
    should "return an array of status code, headers and response" do
      create_snip(:name => "test", :content => "content")
      result = @app.call(mock_env_for_url("/test.text"))
      assert_kind_of Array, result
      assert_equal 200, result[0]
      assert_kind_of Hash, result[1]
      result[2].each{ |output| assert_equal "content", output }
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
      @app = TestApp.new(:soup => soup_path, :root_snip => "custom")
      assert_response_body "custom", "/"
    end

    should "allow specification of the root directory to aide loading external soups" do
      tmp_dir = Dir.tmpdir
      soup_dir = File.join(tmp_dir, "my_soup")
      FileUtils.mkdir_p(soup_dir)
      File.open(File.join(soup_dir, "blah.snip"), "w") { |f| f.write "Hello superfriends" }

      @app = TestApp.new(:soup => "my_soup", :root => tmp_dir)

      assert_equal "Hello superfriends", @app.soup['blah'].content
    end

    should "allow configuration against the class" do
      TestApp.configure do |config|
        config.soups = ["blah", "monkey"]
        config.root = Dir.tmpdir
      end

      app = TestApp.new
      assert_equal ["blah", "monkey"], app.config[:soups]
    end
  end

  context "when detecting the snip renderer" do
    setup do
      @app = TestApp.new(:soup => soup_path)
    end

    should "return the constant refered to in the render_as property of the snip" do
      snip = create_snip(:name => "blah", :render_as => "Raw")
      assert_equal Vanilla::Renderers::Raw, @app.renderer_for(snip)
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
          assert_equal renderer, @app.renderer_for(snip)
        end
      end
    end

    should "respect snip renderers passed in the config" do
      app = TestApp.new(:soup => soup_path, :renderers => {"markdown" => "Vanilla::Renderers::Bold"})
      snip = create_snip(:name => "blah", :extension => "markdown")
      assert_equal Vanilla::Renderers::Bold, app.renderer_for(snip)
    end

    should "return Vanilla::Renderers::Base if no render_as property exists" do
      snip = create_snip(:name => "blah")
      assert_equal Vanilla::Renderers::Base, @app.renderer_for(snip)
    end

    should "return Vanilla::Renderers::Base if the render_as property is blank" do
      snip = create_snip(:name => "blah", :render_as => '')
      assert_equal Vanilla::Renderers::Base, @app.renderer_for(snip)
    end

    should "raise an error if the specified renderer doesn't exist" do
      snip = create_snip(:name => "blah", :render_as => "NonExistentClass")
      assert_raises(NameError) { @app.renderer_for(snip) }
    end

    should "load constants presented as a string" do
      class ::MyRenderer
      end
      app = TestApp.new(:soup => soup_path, :renderers => {"my_renderer" => "MyRenderer"})
      snip = create_snip(:name => "blah", :render_as => "my_renderer")
      assert_equal MyRenderer, app.renderer_for(snip)
    end
  end
end