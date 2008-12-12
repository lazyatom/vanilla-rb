require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Vanilla::Renderers::Markdown, "when rendering" do
  def markdown_snip(attributes)
    create_snip(attributes.merge(:render_as => "Markdown"))
  end
  
  it "should return the snip contents rendered via Markdown" do
    content = <<Markdown
# markdown

* totally
* [rocks](http://www.example.com)!
Markdown
    markdown_snip(:name => "test", :content => content)
    response_body_for("/test").should == BlueCloth.new(content).to_html
  end
  
  it "should include other snips using their renderers" do
    markdown_snip(:name => "test", :content => <<-Markdown
# markdown

and so lets include {another_snip}    
    Markdown
    )
    create_snip(:name => "another_snip", :content => "blah", :render_as => "Bold")
    response_body_for("/test").gsub(/\s+/, ' ').should == "<h1>markdown</h1> <p>and so lets include <b>blah</b> </p>"
  end
end