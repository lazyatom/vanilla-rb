require "test_helper"
require 'vanilla/dynasnip'

describe Dynasnip do
  context "when storing attributes" do

    class ::TestDyna < Dynasnip
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

  context "when rendering usage" do
    class ::ShowUsage < Dynasnip
      usage "This is the usage"
      def handle
        usage
      end
    end

    should "show the usage defined in the snip" do
      assert_equal "This is the usage", ShowUsage.new(app).handle
    end
  end
end
