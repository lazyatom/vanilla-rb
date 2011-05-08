require 'vanilla/dynasnip'

class LinkTo < Dynasnip
  usage %|
The link_to dyna lets you create links between snips: 

  {link_to blah} 

would insert a link to the blah snip.|

  def handle(snip_name, link_text=snip_name, part=nil)
    if app.soup[snip_name]
      %{<a href="#{url_to(snip_name, part)}">#{link_text}</a>}
    else
      %{<a class="missing" href="#{url_to(snip_name, part)}">#{link_text}</a>}
    end
  end

  self
end