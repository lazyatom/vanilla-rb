class PageTitle < Vanilla::Dynasnip
  def handle
    if app.request.snip
      app.request.snip.page_title || app.request.snip.name
    else
      "Not found"
    end
  end

  self
end
