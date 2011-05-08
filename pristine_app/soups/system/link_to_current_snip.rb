require 'vanilla/dynasnip'

class LinkToCurrentSnip < Dynasnip
  usage %|
    Renders a link to the current snip
  |

  def handle(*args)
    %{<a href="#{url_to(app.request.snip_name)}">#{app.request.snip_name}</a>}
  end

  self
end