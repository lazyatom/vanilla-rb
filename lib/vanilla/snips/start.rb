start = Snip.new(:name => 'start')
start.content = <<-START
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