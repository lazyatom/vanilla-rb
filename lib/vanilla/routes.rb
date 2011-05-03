module Vanilla
  # Expects to be able to call 'soup' on whatever it is included into
  module Routes
    def link_to(link_text, snip_name=link_text, part=nil)
      if soup[snip_name]
        %{<a href="#{url_to(snip_name, part)}">#{link_text}</a>}
      else
        %{<a class="missing" href="#{url_to(snip_name, part)}">#{link_text}</a>}
      end
    end

    def url_to(snip_name, part=nil)
      url = "/#{snip_name.gsub(" ", "+")}"
      url += "/#{part}" if part
      url
    end
  end
end
