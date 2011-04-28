require 'vanilla/dynasnip'

class UrlTo < Dynasnip
  def handle(snip_name)
    app.soup[snip_name] ? url_to(snip_name) : "[Snip '#{snip_name}' not found]"
  end
end