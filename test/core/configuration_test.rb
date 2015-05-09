require "test_helper"

context "Configuring a Vanilla app" do
  class TestConfigurationApp < Vanilla::App
  end

  setup do
    TestConfigurationApp.reset!
  end

  context "with defaults" do
    should "set the soups to base and system" do
      assert_equal ["soups/base", "soups/system"], TestConfigurationApp.new.config.soups
    end

    should "set the default layout snip to 'layout'" do
      assert_equal "layout", TestConfigurationApp.new.config.default_layout_snip
    end

    should "set the default root directory to the current directory" do
      assert_equal Dir.pwd, TestConfigurationApp.new.config.root
    end

    should "use Vanilla::Renderers::Base as the default renderer" do
      assert_equal Vanilla::Renderers::Base, TestConfigurationApp.new.config.default_renderer
    end
  end

  context "with a custom root" do
    setup do
      soup_dir = File.join(Dir.tmpdir, "my_soup")
      FileUtils.mkdir_p(soup_dir)
      File.open(File.join(soup_dir, "blah.snip"), "w") { |f| f.write "Hello superfriends" }

      TestConfigurationApp.configure do |c|
        c.root = Dir.tmpdir
        c.soups = ["my_soup"]
      end
    end

    should "expand soup paths relative to the root to aide loading external soups" do
      assert_equal "Hello superfriends", TestConfigurationApp.new.soup['blah'].content
    end
  end

  context "with a custom root_snip" do
    setup do
      TestConfigurationApp.configure do |c|
        c.root_snip = "hello"
      end
    end

    should "use the given snip as the root_snip" do
      assert_equal "hello", TestConfigurationApp.new.config.root_snip
    end
  end

  context "with a specific set of soups" do
    setup do
      TestConfigurationApp.configure do |c|
        c.soups = ["blah", "monkey"]
      end
    end

    should "use only the specified soups" do
      assert_equal ["blah", "monkey"], TestConfigurationApp.new.config.soups
    end

    teardown do
      ["blah", "monkey"].each { |dir| FileUtils.rm_rf(dir) }
    end
  end

  context "with a specific soup" do
    setup do
      @custom_soup = stub('custom soup')
      TestConfigurationApp.configure do |c|
        c.soup = @custom_soup
      end
    end

    should "use only the specified soup" do
      assert_equal @custom_soup, TestConfigurationApp.new.soup
    end
  end

  context "with new renderers" do
    should "load new renderer constants presented as a string" do
      class ::MyRenderer
      end
      TestConfigurationApp.configure do |c|
        c.renderers[:my_renderer] = "MyRenderer"
      end
      snip = create_snip(name: "blah", render_as: "my_renderer")
      assert_equal MyRenderer, TestConfigurationApp.new.renderer_for(snip)
    end

    should "allow existing renderers to be overridden" do
      TestConfigurationApp.configure do |c|
        c.renderers["markdown"] = "Vanilla::Renderers::Bold"
      end
      snip = create_snip(name: "blah", extension: "markdown")
      assert_equal Vanilla::Renderers::Bold, TestConfigurationApp.new.renderer_for(snip)
    end
  end
end
