require "test_helper"

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
    should "load a config file from the current working directory by default" do
      File.expects(:open).with("config.yml").returns(StringIO.new({:soup => soup_path}.to_yaml))
      Vanilla::App.new
    end

    should "load a config file given" do
      File.open("/tmp/vanilla_config.yml", "w") { |f| f.write({:soup => soup_path, :hello => true}.to_yaml) }
      app = Vanilla::App.new("/tmp/vanilla_config.yml")
      assert app.config[:hello]
    end

    should "allow saving of configuration to the same file it was loaded from" do
      config_file = "/tmp/vanilla_config.yml"
      File.open(config_file, "w") { |f| f.write({:soup => soup_path, :hello => true}.to_yaml) }
      app = Vanilla::App.new(config_file)
      app.config[:saved] = true
      app.config.save!

      config = YAML.load(File.open(config_file))
      assert config[:saved]
    end
  end

  context "when detecting the snip renderer" do
    setup do
      @app = Vanilla::App.new(config_file_for_tests)
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

    should "load constants outside of the Vanilla::Renderers module" do
      class ::MyRenderer
      end

      snip = create_snip(:name => "blah", :render_as => "MyRenderer")
      assert_equal MyRenderer, @app.renderer_for(snip)
    end
  end
end