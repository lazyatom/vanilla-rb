require 'vanilla/dynasnip'

class Logout < Dynasnip
  def handle(*args)
    app.request.logout
    "Logged out"
  end
end
