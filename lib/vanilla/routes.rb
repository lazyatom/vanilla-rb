module Vanilla
  module Routes
    def link_to(link_text, snip_name=link_text, part=nil)
      Vanilla.snip_exists?(snip_name) ? Vanilla::Routes.existing_link(link_text, snip_name, part) : Vanilla::Routes.new_link(snip_name)
    end

    def url_to(snip_name, part=nil)
      url = "/#{snip_name}"
      url += "/#{part}" if part
      url
    end

    def url_to_raw(snip_name, part=nil)
      url = Vanilla::Routes.url_to(snip_name, part)
      url += ".raw"
    end

    def existing_link(link_text, snip_name=link_text, part=nil)
      %{<a href="#{Vanilla::Routes.url_to(snip_name, part)}">#{link_text}</a>}
    end

    def edit_link(snip_name, link_text)
      %[<a href="/edit?name=#{snip_name}">#{link_text}</a>]
    end

    def new_link(snip_name="New")
      %[<a href="/new?name=#{snip_name}" class="new">#{snip_name}</a>]
    end

    extend self
  end
end
