require 'vanilla/dynasnip'

class NewSnip < Dynasnip
  snip_name :new

  def handle(*arg)
    app.request.authenticate!

    base_params = {:render_as => '', :content => '', :author => current_user}.update(app.request.params)
    editor = EditSnip.new(app).edit(Soup::Snip.new(base_params))
  end
end
