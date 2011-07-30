require "vanilla/dynasnip"

class Feed < Dynasnip
  def handle(*args)
    app.atom_feed({
      :domain => "yourdomain.example.com", # change this
      :title => "My Feed", # and this,
      :matching => {:kind => "blog"}, # but probably not this, although you can if you like.
    })
  end
  self
end