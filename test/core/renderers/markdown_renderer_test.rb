require "test_helper"

describe Vanilla::Renderers::Markdown do
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
      assert_response_body "<h1>markdown</h1>\n\n<p>and so lets include <b>blah</b></p>", "/test"
    end

    should 'ignore snip inclusions in code-indented blocks' do
      content = <<Markdown
Content

    Some {indented} code
Markdown
      markdown_snip(name: 'test', content: content)
      expected_code = %|<p>Content</p>\n\n<pre><code>Some &#123;indented&#125; code\n</code></pre>|
      assert_response_body expected_code, '/test'
    end
  end

  def markdown_snip(attributes)
    create_snip(attributes.merge(:render_as => "Markdown"))
  end
end
