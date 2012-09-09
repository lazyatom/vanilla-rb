require "test_helper"

context "The rack app" do
  should "handle exceptions by default" do
    create_snip :name => "test", :content => "test"

    app.stubs(:render_in_format).raises("exception-message")

    assert_nothing_raised { visit "/test" }
    assert_equal 500, page.status_code
  end

  should "handle exceptions when raise_errors is false" do
    create_snip :name => "test", :content => "test"

    app.stubs(:render_in_format).raises("exception-message")

    with_raise_errors(false) do
      assert_nothing_raised { visit "/test" }
      assert_equal 500, page.status_code
    end
  end

  should "raise exceptions when raise_errors is true" do
    create_snip :name => "test", :content => "test"

    app.stubs(:render_in_format).raises("exception-message")

    with_raise_errors(true) do
      assert_raises("exception-message") { visit "/test" }
    end
  end

  should "handle missing renderer by default" do
    create_snip :name => "test", :content => "test", :render_as => "unknown"

    assert_nothing_raised { visit "/test" }
    assert_equal 500, page.status_code
  end

  should "handle missing renderer when raise_errors is false" do
    create_snip :name => "test", :content => "test", :render_as => "unknown"

    with_raise_errors(false) do
      assert_nothing_raised { visit "/test" }
      assert_equal 500, page.status_code
    end
  end

  should "raise exceptions when raise_errors is true" do
    create_snip :name => "test", :content => "test", :render_as => "unknown"

    with_raise_errors(true) do
      assert_raises("exception-message") { visit "/test" }
    end
  end

  private

  def with_raise_errors(raise_errors)
    original_raise_errors = app.config.raise_errors
    app.config.raise_errors = raise_errors
    yield
  ensure
    app.config.raise_errors = original_raise_errors
  end
end
