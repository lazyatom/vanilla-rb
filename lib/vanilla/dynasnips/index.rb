require 'vanilla/dynasnip'

class Index < Dynasnip
  def get(*args)
    list = app.soup.all_snips.sort { |a,b| a.updated_at > b.updated_at }.map { |snip|
      "<li>#{link_to snip.name}</li>"
    }
    "<ol>#{list}</ol>"
  end
end
