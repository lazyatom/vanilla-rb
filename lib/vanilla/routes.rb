module Vanilla
  # Expects to be able to call 'soup' on whatever it is included into
  module Routes
    def link_to(link_text, snip_name=link_text, part=nil)
      soup[snip_name] ? existing_link(link_text, snip_name, part) : new_link(snip_name)
    end

    def url_to(snip_name, part=nil)
      url = "/#{snip_name.gsub(" ", "+")}"
      url += "/#{part}" if part
      url
    end

    def url_to_raw(snip_name, part=nil)
      url = url_to(snip_name, part)
      url += ".raw"
    end

    def existing_link(link_text, snip_name=link_text, part=nil)
      %{<a href="#{url_to(snip_name, part)}">#{link_text}</a>}
    end

    def edit_link(snip_name, link_text)
      %[<a href="/edit?name=#{snip_name.gsub(" ", "+")}">#{link_text}</a>]
    end

    def new_link(snip_name="New")
      %[<a href="/new?name=#{snip_name ? snip_name.gsub(" ", "+") : nil}" class="new">#{snip_name}</a>]
    end
  end
end
