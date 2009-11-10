require 'vanilla/dynasnip'
require 'vanilla/dynasnips/login'

class NewSnip < Dynasnip
  # include Login::Helper

  snip_name :new

  def handle(*arg)
    app.request.authenticate!

    base_params = {:render_as => '', :content => '', :author => current_user}.update(app.request.params)
    editor = EditSnip.new(app).edit(Snip.new(base_params))
  end
end
