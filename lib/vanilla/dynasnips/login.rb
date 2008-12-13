require 'vanilla/dynasnip'
require 'yaml'
require 'md5'

class Login < Dynasnip
  module Helper
    def logged_in?
      !current_user.nil?
    end
    
    def current_user
      app.request.session['logged_in_as']
    end
  
    def login_required
      "You need to <a href='/login'>login</a> to do that."
    end
  end
  include Helper
  
  def get(*args)
    if logged_in?
      login_controls
    else
      render(self, 'template')
    end
  end
  
  def post(*args)
    if app.config[:credentials][cleaned_params[:name]] == MD5.md5(cleaned_params[:password]).to_s
      app.request.session['logged_in_as'] = cleaned_params[:name]
      login_controls
    else
      "login fail!"
    end
  end
  
  def delete(*args)
    app.request.session['logged_in_as'] = nil
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
    "logged in as {link_to #{app.request.session['logged_in_as']}}; <a href='/login?_method=delete'>logout</a>"
  end
end
