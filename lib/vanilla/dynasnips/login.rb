require 'vanilla/dynasnip'

class Login < Dynasnip
  def get(*args)
    if app.request.authenticated?
      login_controls
    else
      render(self, 'template')
    end
  end

  def post(*args)
    if app.request.authenticate!
      login_controls
    else
      "login fail!"
    end
  end

  def delete(*args)
    app.request.logout
    "Logged out"
  end

  attribute :template, <<-EHTML
    <form action='/login' method='post'>
    <label>Name: <input type="text" name="name"></input></label>
    <label>Password: <input type="password" name="password"></input></label>
    <button>login</button>
    </form>
  EHTML

  private

  def login_controls
    "logged in as #{link_to app.request.user}; <a href='/login?_method=delete'>logout</a>"
  end
end
