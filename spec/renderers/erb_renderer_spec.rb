require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Vanilla::Renderers::Erb, "when rendering" do
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
  
  it "should expose the snip as an instance variable" do
    erb_snip(:name => "test", :content => "<%= @snip.name %>")
    response_body_for("/test").should == "test"
  end
  
  it "shoudl expose the app as an instance variable" do
    erb_snip(:name => "test", :content => "<%= @app.class.name %>")
    response_body_for("/test").should == "Vanilla::App"
  end
end