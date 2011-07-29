class Feed < Dynasnip
  def handle(*args)
    app.atom_feed({
      :domain => "yourdomain.example.com", # change this!
      :title => "My Feed", # and this!
    })
  end
  self
end