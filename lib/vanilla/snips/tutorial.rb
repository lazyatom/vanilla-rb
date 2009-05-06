tutorial = Snip.new(:name => 'vanilla-rb-tutorial')
tutorial.render_as = "Markdown"
tutorial.content = <<-END_OF_TUTORIAL
Basic Concepts
------------

Every piece of information displayed here is stored as a {link_to snip}. Snips, within their contents, can also reference other snips. When you request a snip, it will render into a page (or another kind of response), and also render any snips that it internally references.

For example, consider the snip {link_to tutorial-basic-snip-inclusion}:

{raw tutorial-basic-snip-inclusion}

When this snip is rendered, it appears like this:

{tutorial-basic-snip-inclusion}

Notice the use of curly brackets to reference one snip from inside another. Vanilla.rb finds these references to snips, then renders that snip and replaces it in the first snip. Neat!

Renderers
--------

The way that a snip is rendered depends on whether or not it has a `render_as` attribute set. For instance, the `render_as` property of this snip ({link_to vanilla-rb}) is "Markdown". This means that the `content` of this snip will be passed through `Vanilla::Renderers::Markdown` before it is then rendered to the page. There are several different renders provided by Vanilla.rb at the moment:

  * Markdown - as described above
  * Textile - which performs similarly for Textile. This means that you can mix how you write the content of snips!
  * Raw - which simply returns the content of the snip, as-is. If you attach a `.raw` extension to this url, you'll see it in action
  * Bold - simply wraps the content in bold. It's a demo, essentially.
  * Erb - passes the snip contents through Ruby's `Erb` library. It also makes some information available for use by ruby code within the snip's contents
  * Ruby - parses the snips content as Ruby itself.

It's using this last renderer that a second concept of Vanilla is implemented - dynasnips.


Dynasnips
--------

Because the curly braces simply cause a snip to be rendered, we can use this in conjunction with the Ruby renderer to run actual code. For instance, in the snip above:

{raw tutorial-basic-snip-inclusion}

we can see a reference to the `link_to` snip - <tt>&#123;link\_to snip&#125;</tt>.

Lets look at the raw content of `link_to`:

{raw link_to}

As you can see, it simply refers to the Ruby class `LinkTo`, which is contained within the vanilla-rb codebase. When the Ruby renderer is called, expects the given code to evaulate to a Ruby class. It then instantiates the class, and calls a `handle` method on the instance, passing it any other arguments from the snip inclusion. So, in the case of <tt>&#123;link\_to snip&#125;</tt>, the only argument is `snip`.

Vanilla.rb includes a number of dynasnips by default. Here are a couple:

  * `rand`, which generates a random number (a silly demo really); {link_to rand}, or an example: {rand}
  * `link_to`, to produce a link to another snip
  * `kind`, which selects and renders sets of snips based on their `kind` attribute (this is how the blog is currently implemented)
  * `raw`, which displays the raw contents of a snip
  * `edit`, which implements the editor
  * `index`, which shows all of the available snips: {link_to index}
  * ... and several others.

While dynasnip classes can be provided as part of the vanilla codebase, it's envisioned that much of these will be created by end users in their own sites, either by refering to local classes, or defining the classes directly as the content. Here's an example of that, as the raw content of {link_to hello\_world}:

{raw hello_world}

which, when rendered, gives:

{hello_world}

Note that the `handle` method can take one (optional) argument. Lets try including it with <tt>&#123;hello\_world Dave&#125;</tt>:

{hello_world Dave}

Anyway - that should be enough to get you started.
END_OF_TUTORIAL

tutorial.save

tutorial_basic_snip_inclusion = Snip.new(:name => 'tutorial-basic-snip-inclusion')
tutorial_basic_snip_inclusion.content = <<-EOS
This is a snip, which includes another {link_to snip}: {tutorial-another-snip}
EOS
tutorial_basic_snip_inclusion.save

tutorial_another_snip = Snip.new(:name => 'tutorial-another-snip')
tutorial_another_snip.content = "this is another snip!"
tutorial_another_snip.save

hello_world = Snip.new(:name => 'hello_world', :render_as => "Ruby")
hello_world.content = <<-END_OF_RUBY
class HelloWorld
  # although the name doesn't need to match the snip name,
  # it's simple to follow that convention where appropriate

  def handle(name=nil)
    if name
      "Hey \#{name} - Hello World!"
    else
      "Hello World!"
    end
  end

  # note that this code must evaluate to a class. One way of achieving that is by 
  # putting 'self' at the end of the class definition.
  self
end
# Another way is by referring to the class at the end of the content. Either works fine.
HelloWorld
END_OF_RUBY
hello_world.save

snip = Snip.new(:name => 'snip', :render_as => "Markdown")
snip.content = <<-EOS
A snip is the basic building block of information for {link_to vanilla-rb}. Essentially, it is a piece of content with arbitrary attributes. Vanilla anticipates the presence of some key attributes:

 * `name` - the name of the snip, which is how it will be referred to. The `name` of this snip is _snip_.
 * `content` - the default part of the snip to render. You can see the `content` of this snip <a href="/snip/content.raw">here</a>.
 * `render_as` - the name of the renderer to use when rendering the content. The `render_as` of this snip is {snip.render_as}.

One implementation of the snip store is {link_to soup}.
EOS
snip.save

soup = Snip.new(:name => 'soup')
soup.content = <<-EOS
Soup is a data store supporting the {link_to snip}-space that {link_to vanilla-rb} expects.

It's hosted on github <a href="http://github.com/lazyatom/soup">here</a>.
EOS
soup.save

vanilla_rb = Snip.new(:name => 'vanilla-rb', :render_as => "Markdown")
vanilla_rb.content = <<-EOS
Vanilla.rb is the software powering this site. It's a sort-of wiki/bliki thing, based on {link_to vanilla}.

Here's the [introductory blog post][3].

It's developed on [github][1], and has a [lighthouse bug tracker][2]. At the moment it's not very well documented, since I'm exploring how the concept might work and the internals are subject to change. However, please do play around with it.

Here's the tutorial (helpfully included from {link_to vanilla-rb-tutorial}).

{vanilla-rb-tutorial}


[1]: http://github.com/lazyatom/vanilla
[2]: http://lazyatom.lighthouseapp.com/projects/11797-vanilla/tickets
[3]: http://interblah.net/introducing-vanilla-rb
EOS
vanilla_rb.save

vanilla = Snip.new(:name => 'vanilla')
vanilla.content = <<-EOS
The bliki upon which {link_to vanilla-rb} is based, writen by [Christian Langreiter][1]

[Official Web HQ][2]

[1]: http://www.langreiter.com
[2]: http://www.vanillasite.at
EOS
vanilla.save