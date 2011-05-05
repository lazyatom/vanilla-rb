require "test_helper"

describe Vanilla::Renderers::Erb do
  context "when rendering" do
    should "insert evaluated Erb content into the snip" do
      erb_snip(:name => "test", :content => "<%= 1 + 2 %>")
      assert_response_body "3", "/test"
    end

    should "evaluate Erb content in the snip" do
      erb_snip(:name => "test", :content => "<% if false %>monkey<% else %>donkey<% end %>")
      assert_response_body "donkey", "/test"
    end

    should "expose the snip as an instance variable" do
      erb_snip(:name => "test", :content => "<%= @snip.name %>")
      assert_response_body "test", "/test"
    end

    should "expose the app as an instance variable" do
      erb_snip(:name => "test", :content => "<%= @app.class.name %>")
      assert_response_body "TestApp", "/test"
    end
  end

  def erb_snip(params)
    create_snip(params.merge(:render_as => "Erb"))
  end
end
