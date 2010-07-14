require 'vanilla/dynasnip'

class Title < Dynasnip
  def handle
    app.request.snip.__send__(:title) || app.request.snip.__send__(:name)
  end
end