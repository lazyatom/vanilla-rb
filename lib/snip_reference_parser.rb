require 'treetop'
Treetop.load "snip_reference"

module SnipReference
  module SnipCall
    def snip
      elements[1].text_value
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
  module HashArgumentList
    def to_arguments
      args = elements[0].to_arguments
      # p elements[0].elements[4]
      # args.merge(elements[0].elements[4].elements[1].to_arguments) if elements[0].elements[4] && elements[0].elements[4].elements
      args
    end
  end
  module TypicalHashArgument
    def to_arguments
      {elements[0].text_value.to_sym => elements[4].text_value}
    end
  end
  module NormalArgument
    def to_arguments
      [text_value]
    end
  end
end

require 'test/unit'

class SnipReferenceParserTest < Test::Unit::TestCase
  examples = {
    %|{snip}|                               => {:snip => 'snip', :arguments => []},
    %|{snip argument}|                      => {:snip => 'snip', :arguments => ["argument"]},
    %|{"snip with spaces"}|                 => {:snip => 'snip with spaces', :arguments => []},
    %|{snip-with-dashes}|                   => {:snip => 'snip-with-dashes', :arguments => []},
    %|{snip_with_underscores}|              => {:snip => 'snip_with_underscores', :arguments => []},
    %|{"snip with spaces" argument}|        => {:snip => 'snip with spaces', :arguments => ['argument']},
    %|{'snip with spaces' argument}|        => {:snip => 'snip with spaces', :arguments => ['argument']},
    %|{snip "argument with spaces"}|        => {:snip => 'snip', :arguments => ['argument with spaces']},
    %|{snip 'argument with spaces'}|        => {:snip => 'snip', :arguments => ['argument with spaces']},
    %|{snip arg1,arg2}|                     => {:snip => 'snip', :arguments => ['arg1', 'arg2']},
    %|{snip arg1, arg2}|                    => {:snip => 'snip', :arguments => ['arg1', 'arg2']},
    %|{snip "argument with spaces", arg2}|  => {:snip => 'snip', :arguments => ['argument with spaces', 'arg2']},
    %|{"snip with spaces" arg1, arg2}|      => {:snip => 'snip with spaces', :arguments => ['arg1', 'arg2']},
    # %|{snip key1:value1,key2:value2}| => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    # %|{snip key1:value1, key2:value2}| => {:snip => 'snip', :arguments => {:key}},
    # %|{snip key1: value1, key2: value2}|,
    # %|{snip key1 => value1, key2 => value2}|,
    # %|{snip :key1 => value1, :key2 => value2}|,
    # %|{snip key1:"value with spaces"}|,
    %|{snip key1 => "value with spaces"}|   => {:snip => 'snip', :arguments => {:key1 => "value with spaces"}}
  }
  
  def setup
    @parser = SnipReferenceParser.new
  end
  
  examples.each do |example, expected|
    define_method :"test_parsing_#{example}" do
      tree = @parser.parse(example)
      p tree
      if tree
        assert_equal expected[:snip], tree.snip
        assert_equal expected[:arguments], tree.arguments
      else
        flunk "failed to parse: #{example}"
      end
    end
  end
end