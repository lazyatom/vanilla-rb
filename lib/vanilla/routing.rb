module Vanilla
  module Routing

    def url_to(snip_name, part=nil)
      return "/" if snip_name == config.root_snip && part.nil?
      url = "/#{snip_name.gsub(" ", "+")}"
      url += "/#{part}" if part
      url
    end

    # i.e. / or nothing
    ROOT = /\A\/?\Z/
    # i.e. /start, /start.html
    SNIP = /\A\/([\w\-\s]+)(\/|\.(\w+))?\Z/
    # i.e. /blah/part, /blah/part.raw
    SNIP_AND_PART = /\A\/([\w\-\s]+)\/([\w\-\s]+)(\/|\.(\w+))?\Z/

    # Returns an array of three components;
    # * the snip
    # * the part
    # * the format
    def self.parse(path)
      case CGI.unescape(path)
      when ROOT
        [nil, nil, nil]
      when SNIP
        [$1, nil, $3]
      when SNIP_AND_PART
        [$1, $2, $4]
      else
        []
      end
    end
  end
end
