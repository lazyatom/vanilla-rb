require 'vanilla/dynasnip'

class EditLink < Dynasnip
  usage %|
You can use the edit_link snip to insert links for editing other snips. For example: 

  &#123;edit_link blah&#125; 
  
would insert a link to an editor for the blah snip.

You can also give a custom piece of text for the link, like this:

  &#123;edit_link blah,link-name&#125;|
  
  def handle(*args)
    snip_name = args[0] || app.request.snip_name
    link_text = args[1] || "Edit"
    Vanilla::Routes.edit_link(snip_name, link_text)
  end
end