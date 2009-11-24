module SnipReference
  module SnipCall
    def snip
      elements[1].name
    end
    def attribute
      elements[1].attribute
    end
    def arguments
      if elements[2] && elements[2].elements
        r = elements[2].elements[1].to_arguments
        r.flatten! if r.respond_to?(:flatten!)
        r
      else
        []
      end
    end
  end
  module SnipName
    def name
      text_value
    end
    def attribute
      nil
    end
  end
  module SnipNameWithAttribute
    def name
      elements[0].text_value
    end
    def attribute
      elements[2].text_value
    end
  end
  module QuotedWord
    def text_value
      elements[1].text_value
    end
  end
  module ArgumentList
    def to_arguments
      args = elements[0].to_arguments
      if args.is_a?(Array)
        args << elements[1].elements[1].to_arguments if elements[1].elements
      elsif args.is_a?(Hash)
        args.merge!(elements[1].elements[1].to_arguments) if elements[1].elements
      end
      args
    end
  end
  module HashArgument
    def to_arguments
      key = elements[0].text_value
      key = $1 if key =~ /\A:(.*)\Z/
      {key.to_sym => elements[4].text_value}
    end
  end
  module NormalArgument
    def to_arguments
      [text_value]
    end
  end
end

require 'treetop'
require 'vanilla/snip_reference'