require "test_helper"

context "The current_snip dynasnip" do
  should "render the snip from the current request" do
    set_main_template "<layout>{current_snip}</layout>"
    create_snip name: "test", content: "test"

    visit "/test"

    assert page.has_css?("layout", text: "test")
  end

  should "render a given attribute of the current snip" do
    create_snip name: "test", content: "this is my {current_snip part}", part: "underbelly"
    visit "/test"
    assert page.has_content?("this is my underbelly")
  end

  should "render based on the requested snip, not the including snip" do
    create_snip name: "test", content: "this is my {current_snip part}", part: "underbelly"
    create_snip name: "blah", content: "{test}", part: "flange"
    visit "/blah"
    assert page.has_content?("this is my flange")
  end

  should "be able to handle snips with spaces in their names" do
    create_snip name: "test snip", content: "this is a test"
    visit "/test+snip"
    assert page.has_content?("this is a test")
  end

  context "when the requested part of a snip is missing" do
    setup do
      set_main_template "<layout>{current_snip}</layout>"
      create_snip name: "test", content: "test"

      visit "/test/monkey"
    end

    should "render an explanatory message" do
      assert page.has_content?(%{Couldn't find part "monkey" for snip "test"})
    end
  end
end
