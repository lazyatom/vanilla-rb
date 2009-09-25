app = Vanilla::App.new(ENV['VANILLA_CONFIG'])
start = app.snip(:name => 'start')
start.content = <<-START
Welcome to Vanilla.rb
=============

Vanilla.rb is a web-experiment (a _websperiment_?) about storing and reusing data on a website. It can also function as a [bliki](http://www.wikipedia.com/wiki/Bliki). 

The fundamental building block is the 'snip', which is a malleable object that can store content and arbitrary metadata.

---

This is the {link_to start} snip, which is the default home page.

You might want to check out the {link_to vanilla-rb-tutorial} snip. 

In fact - I'll include it here for you:

{vanilla-rb-tutorial}

---

That was the end of the tutorial snip. We're back in the start snip now. There's also the {link_to test} snip, that might be interesting.

Anyway, welcome.
START
start.render_as = "Markdown"
start.save