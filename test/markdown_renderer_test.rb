require "test_helper"

class MarkdownRendererTest < Vanilla::TestCase
  context "when rendering" do
    should "return the snip contents rendered via Markdown" do
      content = <<Markdown
# markdown

* totally
* [rocks](http://www.example.com)!
Markdown
      markdown_snip(:name => "test", :content => content)
      assert_response_body BlueCloth.new(content).to_html, "/test"
    end

    should "include other snips using their renderers" do
      markdown_snip(:name => "test", :content => <<-Markdown
# markdown

and so lets include {another_snip}
Markdown
      )
      create_snip(:name => "another_snip", :content => "blah", :render_as => "Bold")
      assert_equal "<h1>markdown</h1> <p>and so lets include <b>blah</b></p>", response_body_for("/test").gsub(/\s+/, ' ')
    end
  end

  private

  def markdown_snip(attributes)
    create_snip(attributes.merge(:render_as => "Markdown"))
  end
end
