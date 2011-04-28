require 'vanilla/dynasnip'

class PageTitle < Dynasnip
  def handle
    app.request.snip.__send__(:page_title) || app.request.snip.__send__(:name)
  end

  self
end