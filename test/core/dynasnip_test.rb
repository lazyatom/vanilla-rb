require "test_helper"
require 'vanilla/dynasnip'

describe Dynasnip do
  context "when storing attributes" do

    class TestDyna < Dynasnip
      attribute :test_attribute, "test attribute content"
    end

    should "make the attribute available as an instance method" do
      assert_equal "test attribute content", TestDyna.new(app).test_attribute
    end

    should "store the attribute in the soup" do
      app.soup << TestDyna.snip_attributes
      assert_equal "test attribute content", app.soup['test_dyna'].test_attribute
    end

    should "allow the attribute to be overriden by the soup contents" do
      app.soup << TestDyna.snip_attributes
      snip = app.soup['test_dyna']
      snip.test_attribute = "altered content"
      snip.save

      assert_equal "altered content", TestDyna.new(app).test_attribute
    end
  end

  context "determining name" do
    module X
      class TestDyna < Dynasnip
        def handle(*args)
          "name: #{snip_name}"
        end
      end
    end

    should "strip out modules from the name" do
      assert_equal "test_dyna", X::TestDyna.snip_name
    end

    should "allow the snip to reference its own name" do
      assert_equal "name: test_dyna", X::TestDyna.new(app).handle
    end
  end

  context "setting name" do
    class AnotherDyna < Dynasnip
    end

    should "be possible" do
      AnotherDyna.snip_name "some_other_name"
      assert_equal "some_other_name", AnotherDyna.snip_name
    end
  end

  context "when rendering usage" do
    class ::ShowUsage < Dynasnip
      def handle
        usage
      end
    end

    should "show the usage defined in the snip" do
      ShowUsage.usage "This is the usage"

      assert_equal "This is the usage", ShowUsage.new(app).handle
    end

    should "automatically escape curly braces to prevent snip inclusion" do
      ShowUsage.usage "like {this}"

      assert_equal "like &#123;this&#125;", ShowUsage.new(app).handle
    end
  end
end
