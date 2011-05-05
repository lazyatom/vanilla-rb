require "test_helper"

describe Vanilla::Request do
  context "when requesting the root" do
    setup { @request = Vanilla::Request.new(mock_env_for_url("/"), app) }

    should "set snip to 'start' by default" do
      assert_equal "start", @request.snip_name
    end

    should "set format to 'html'" do
      assert_equal "html", @request.format
    end
  end

  context "when requesting urls" do
    setup { @request = Vanilla::Request.new(mock_env_for_url("/snip"), app) }

    should "use the first segement as the snip name" do
      assert_equal "snip", @request.snip_name
    end

    should "try to load the snip based on the snip name" do
      app.soup.expects(:[]).with('snip').returns(:snip)
      assert_equal :snip, @request.snip
    end

    should "have no part if the url contains only a single segment" do
      assert_equal nil, @request.part
    end

    should "have a default format of html" do
      assert_equal 'html', @request.format
    end

    should "determine the request method" do
      assert_equal 'get', @request.method
    end
  end

  context "when requesting a snip part" do
    setup { @request = Vanilla::Request.new(mock_env_for_url("/snip/part"), app) }

    should "use the first segment as the snip, and the second segment as the part" do
      assert_equal "snip", @request.snip_name
      assert_equal "part", @request.part
    end

    should "have a default format of html" do
      assert_equal "html", @request.format
    end
  end

  context "when requesting a snip with a format" do
    setup { @request = Vanilla::Request.new(mock_env_for_url("/snip.raw"), app) }

    should "use the extension as the format" do
      assert_equal "raw", @request.format
    end

    should "retain the filename part of the path as the snip" do
      assert_equal "snip", @request.snip_name
    end
  end

  context "when requesting a snip part with a format" do
    setup { @request = Vanilla::Request.new(mock_env_for_url("/snip/part.raw"), app) }

    should "use the extension as the format" do
      assert_equal "raw", @request.format
    end

    should "retain the first segment of the path as the snip" do
      assert_equal "snip", @request.snip_name
    end

    should "use the filename part of the second segment as the snip part" do
      assert_equal "part", @request.part
    end
  end

  context "when requested with a _method parameter" do
    should "return the method using the parameter" do
      assert_equal 'put', Vanilla::Request.new(mock_env_for_url("/snip?_method=put"), app).method
    end
  end
end
