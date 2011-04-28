require 'vanilla/dynasnip'

class CurrentSnip < Dynasnip
  usage %|
    The current_snip dyna normally returns the result of rendering the snip named by the
    'snip' value in the parameters. This way, it can be used in templates to place the currently
    requested snip, in its rendered form, within the page.

    It can also be used to determine an attribute of the current snip in a consistent way:

      {current_snip name}

    will output the name of the current snip.
  |

  def handle(attribute=nil)
    if attribute
      app.request.snip.__send__(attribute)
    else
      if app.request.snip
        app.render(app.request.snip, app.request.part)
      else
        app.response.status = 404
        %{Couldn't find snip "#{app.request.snip_name}"}
      end
    end
  end
  self
end