require File.join(File.dirname(__FILE__), *%w[.. spec_helper])
require "vanilla/renderers/erb"

describe Vanilla::Renderers::Erb, "when rendering" do
  include Vanilla::Test
  
  before(:each) do
    Vanilla::Test.setup_clean_environment
  end
  
  def erb_snip(params)
    create_snip(params.merge(:render_as => "Erb"))
  end

  it "should insert evaluated Erb content into the snip" do
    erb_snip(:name => "test", :content => "<%= 1 + 2 %>")
    response_body_for("/test").should == "3"
  end
  
  it "should evaluate Erb content in the snip" do
    erb_snip(:name => "test", :content => "<% if false %>monkey<% else %>donkey<% end %>")
    response_body_for("/test").should == "donkey"
  end
  
  it "should expose instance variables from within the renderer instance" do
    erb_snip(:name => "test", :content => "<%= @snip.name %>")
    response_body_for("/test").should == "test"
  end
  
end