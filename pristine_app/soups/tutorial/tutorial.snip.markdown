{tutorial-links}

Snips - the basic concept
------------

Firstly, open the raw contents of this snip - either in your editor (search for `vanilla-rb-tutorial.snip`), or by opening <a href="{current_snip name}.raw">this snip in raw format</a> in a new window or tab. Ready? OK.

Every piece of information displayed here is stored as a {link_to snip}. Snips, within their contents, can also reference other snips. When you request a snip, it will render into a page (or another kind of response), and also render any snips that it internally references.

For example, consider the snip {link_to tutorial-basic-snip-inclusion}:

    {raw tutorial-basic-snip-inclusion}

When this snip is rendered, it appears like this:

> {tutorial-basic-snip-inclusion}

Notice the use of curly brackets to reference one snip from inside another. {link_to vanilla-rb} finds these references to snips, then renders that snip and replaces it in the first snip. Neat!

Renderers
--------

The way that a snip is rendered depends on whether or not it has an extension, or a `render_as` attribute set. For instance, the extention of this snip is `{current_snip extension}`, and the `render_as` property of `markdown_example` is `Markdown`. Scroll to the bottom of the raw markdown_example snip in your editor, and you'll see this being declared.

This means that the `content` of this snip will be passed through `Vanilla::Renderers::Markdown` before it is then rendered to the page. There are several different renders provided by Vanilla.rb at the moment:

  * Markdown - as described above
  * Textile - which performs similarly for Textile. This means that you can mix how you write the content of snips!
  * Raw - which simply returns the content of the snip, as-is. If you attach a `.raw` extension to this url, you'll see it in action
  * Bold - simply wraps the content in bold. It's a demo, essentially.
  * Erb - passes the snip contents through Ruby's `Erb` library. It also makes some information available for use by ruby code within the snip's contents
  * Ruby - parses the snips content as Ruby itself.

You can see a lot of these renderers being exercised in the {link_to test} snip.

It's using this last renderer that a second concept of Vanilla is implemented - dynasnips.


Dynasnips
--------

Because the curly braces simply cause a snip to be rendered, we can use this in conjunction with the Ruby renderer to run actual code. For instance, in the snip above:

    {raw tutorial-basic-snip-inclusion}

we can see a reference to the `link_to` snip - <tt>&#123;link\_to snip&#125;</tt>.

Lets look at the raw content of `link_to`:

    {raw link_to}

As you can see, it simply refers to the Ruby class `LinkTo`, which is contained within the vanilla-rb codebase. When the Ruby renderer is called, expects the given code to evaulate to a Ruby class. It then instantiates the class, and calls a `handle` method on the instance, passing it any other arguments from the snip inclusion. So, in the case of <tt>&#123;link\_to snip&#125;</tt>, the only argument is `snip`.

### Included Dynasnips

Vanilla.rb includes a number of dynasnips by default. Here are a couple:

  * `link_to`, to produce a link to another snip
  * `raw`, which displays the raw contents of a snip
  * `index`, which shows all of the available snips: {link_to index}
  * ... and several others.


Anyway - that should be enough to get you started.

{tutorial-links}

:updated_at: 2011-04-28 16:21:00 +01:00