require 'vanilla/dynasnip'
require 'vanilla/dynasnips/login'

class NewSnip < Dynasnip
  include Login::Helper
  
  snip_name :new
  
  def handle(*arg)
    return login_required unless logged_in?
    editor = EditSnip.new(app).edit(Snip.new(:name => 'newsnip', :render_as => ''))
  end
end