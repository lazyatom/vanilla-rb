require 'treetop'

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
      args << elements[1].elements[1].to_arguments if elements[1].elements
      args
    end
  end
  module NormalArgument
    def to_arguments
      [text_value]
    end
  end
end


if __FILE__ == $0

Treetop.load "snip_reference"
require 'test/unit'

class SnipReferenceParserTest < Test::Unit::TestCase
  examples = {
    %|{snip}|                               => {:snip => 'snip', :attribute => nil, :arguments => []},
    %|{snip argument}|                      => {:snip => 'snip', :attribute => nil, :arguments => ["argument"]},
    %|{"snip with spaces"}|                 => {:snip => 'snip with spaces', :attribute => nil, :arguments => []},
    %|{snip-with-dashes}|                   => {:snip => 'snip-with-dashes', :attribute => nil, :arguments => []},
    %|{snip_with_underscores}|              => {:snip => 'snip_with_underscores', :attribute => nil, :arguments => []},
    %|{"snip with spaces" argument}|        => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['argument']},
    %|{'snip with spaces' argument}|        => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['argument']},
    %|{snip "argument with spaces"}|        => {:snip => 'snip', :attribute => nil, :arguments => ['argument with spaces']},
    %|{snip 'argument with spaces'}|        => {:snip => 'snip', :attribute => nil, :arguments => ['argument with spaces']},
    %|{snip arg1,arg2}|                     => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', 'arg2']},
    %|{snip arg1, arg2}|                    => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', 'arg2']},
    %|{snip "argument with spaces", arg2}|  => {:snip => 'snip', :attribute => nil, :arguments => ['argument with spaces', 'arg2']},
    %|{"snip with spaces" arg1, arg2}|      => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['arg1', 'arg2']},
    %|{snip.snip_attribute}|                => {:snip => 'snip', :attribute => 'snip_attribute', :arguments => []},
    %|{snip."spaced attribute"}|            => {:snip => 'snip', :attribute => 'spaced attribute', :arguments => []},
    %|{"snip with spaces".attribute}|       => {:snip => 'snip with spaces', :attribute => 'attribute', :arguments => []},
    %|{snip.snip_attribute arg}|            => {:snip => 'snip', :attribute => 'snip_attribute', :arguments => ['arg']},
    # %|{snip key1:value1,key2:value2}| => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    # %|{snip key1:value1, key2:value2}| => {:snip => 'snip', :arguments => {:key}},
    # %|{snip key1: value1, key2: value2}|,
    # %|{snip key1 => value1, key2 => value2}|,
    # %|{snip :key1 => value1, :key2 => value2}|,
    # %|{snip key1:"value with spaces"}|,
    # %|{snip key1 => "value with spaces"}|   => {:snip => 'snip', :arguments => {:key1 => "value with spaces"}}
  }
  
  def setup
    @parser = SnipReferenceParser.new
  end
  
  examples.each do |example, expected|
    define_method :"test_parsing_#{example}" do
      tree = @parser.parse(example)
      if tree
        assert_equal expected[:snip], tree.snip
        assert_equal expected[:arguments], tree.arguments
      else
        flunk "failed to parse: #{example}"
      end
    end
  end
end

end