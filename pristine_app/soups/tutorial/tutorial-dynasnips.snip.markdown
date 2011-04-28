{tutorial-links}

Dynasnips
=========

As mentioned in the general {link_to tutorial}, dynamic content is built in vanilla using "dynasnips". These are snips who content depends on more than just their content.

Typically they are rendered by the `Vanilla::Renderers::Ruby` renderer. Lets look again at the raw content of `link_to`:

    {raw link_to}

As you can see, it simply refers to the Ruby class `LinkTo`, which is contained within the vanilla-rb codebase. When the Ruby renderer is called, expects the given code to evaulate to a Ruby class. It then instantiates the class, and calls a `handle` method on the instance, passing it any other arguments from the snip inclusion.

You can pass arguments to dynasnips in a number of ways. All of the following are valid:

* &#123;dynasnip apple&#125;
* &#123;dynasnip apple, banana&#125;
* &#123;dynasnip apple, big banana, cherry&#125;
* &#123;dynasnip apple, big banana, "lovely lucious cherry"&#125;
* &#123;dynasnip apple => true, banana => false&#125;
* &#123;dynasnip apple: true, banana: false&#125;

Where a simple list of arguments is given, these will be passed to the `handle` method as an array. If a ruby-hash-like syntax is used, a hash of these options will be passed.

Of course, it depends entirely on the implementation of the dynasnip what arguments it expects and accepts; some may require a flat list, while others may require hash-like named arguments.


Writing your own Dynasnips
--------------------------

While dynasnip classes can be provided as part of the vanilla codebase, it's envisioned that much of these will be created by end users in their own sites, either by refering to local classes, or defining the classes directly as the content. Here's an example of that, as the raw content of `hello_world`:

    {raw hello_world}

It's important that the contents of the snip evaluate to a Ruby class; this is easy to achieve by placing `self` as the last statement in the class definition, or referencing the class at the end of the snip; both are shown above.

If we include the dynasnip here as <tt>&#123;hello\_world&#125;</tt>, gives:

> {hello_world}

Note that the `handle` method can take one (optional) argument. Lets try including it with <tt>&#123;hello\_world Dave&#125;</tt>:

> {hello_world Dave}


HTTP Verbs
----------

By default, the Ruby renderer will attempt to call `handle` on a dynasnip instance, but if the instance responds to methods corresponding to the HTTP Verbs - `get`, `post`, `put`, or `delete` - then these methods will be called instead.

This means you can have a single dynasnip which responds differently when receiving a `POST` request - quite useful if you want to write dynasnips that generate and respond to forms, like the `comments` dynasnip in your `extras` soup directory.

There's really no limit to what you can do with dynasnips - only what you can imagine.


{tutorial-links}