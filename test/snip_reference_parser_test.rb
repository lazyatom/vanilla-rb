require "test_helper"
Treetop.load File.join(File.dirname(__FILE__), *%w[.. lib vanilla snip_reference])

class SnipReferenceParserTest < Test::Unit::TestCase
  examples = {
    %|{snip}|                                  => {:snip => 'snip', :attribute => nil, :arguments => []},
    %|{snip argument}|                         => {:snip => 'snip', :attribute => nil, :arguments => ["argument"]},
    %|{"snip with spaces"}|                    => {:snip => 'snip with spaces', :attribute => nil, :arguments => []},
    %|{snip-with-dashes}|                      => {:snip => 'snip-with-dashes', :attribute => nil, :arguments => []},
    %|{snip_with_underscores}|                 => {:snip => 'snip_with_underscores', :attribute => nil, :arguments => []},
    %|{"snip with spaces" argument}|           => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['argument']},
    %|{'snip with spaces' argument}|           => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['argument']},
    %|{snip "argument with spaces"}|           => {:snip => 'snip', :attribute => nil, :arguments => ['argument with spaces']},
    %|{snip 'argument with spaces'}|           => {:snip => 'snip', :attribute => nil, :arguments => ['argument with spaces']},
    %|{snip arg1,arg2}|                        => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', 'arg2']},
    %|{snip arg1, arg2}|                       => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', 'arg2']},
    %|{snip "argument with spaces", arg2}|     => {:snip => 'snip', :attribute => nil, :arguments => ['argument with spaces', 'arg2']},
    %|{"snip with spaces" arg1, arg2}|         => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['arg1', 'arg2']},
    %|{snip arg1,,arg3}|                       => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', nil, 'arg3']},
    %|{snip arg1, ,arg3}|                      => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', nil, 'arg3']},
    %|{snip.snip_attribute}|                   => {:snip => 'snip', :attribute => 'snip_attribute', :arguments => []},
    %|{snip."spaced attribute"}|               => {:snip => 'snip', :attribute => 'spaced attribute', :arguments => []},
    %|{"snip with spaces".attribute}|          => {:snip => 'snip with spaces', :attribute => 'attribute', :arguments => []},
    %|{snip.snip_attribute arg}|               => {:snip => 'snip', :attribute => 'snip_attribute', :arguments => ['arg']},
    %|{snip arg with spaces}|                  => {:snip => 'snip', :attribute => nil, :arguments => ['arg with spaces']},
    %|{snip arg with spaces, another arg}|     => {:snip => 'snip', :attribute => nil, :arguments => ['arg with spaces', 'another arg']},
    %|{snip key1=>value1, key2 => value2}|     => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    %|{snip.attribute key1=>value1}|           => {:snip => 'snip', :attribute => 'attribute', :arguments => {:key1 => 'value1'}},
    %|{snip key1 => value1, key2 => value2}|   => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    %|{snip :key1 => value1, :key2 => value2}| => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    %|{snip key1 => "value with spaces"}|      => {:snip => 'snip', :arguments => {:key1 => "value with spaces"}},
    # %|{snip "key with spaces" => value} |      => {:snip => 'snip', :arguments => {:"key with spaces" => "value"}},
    %|{snip key1:value1,key2:value2}|          => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    %|{snip key1:value1, key2:value2}|         => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    %|{snip key1: value1, key2: value2}|       => {:snip => 'snip', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
    %|{snip key1:"value with spaces"}|         => {:snip => 'snip', :arguments => {:key1 => 'value with spaces'}}
  }
  
  def setup
    @parser = SnipReferenceParser.new
  end
  
  examples.each do |example, expected|
    define_method :"test_parsing_#{example}" do
      reference = @parser.parse(example)
      if reference
        assert_equal expected[:snip],      reference.snip
        assert_equal expected[:attribute], reference.attribute
        assert_equal expected[:arguments], reference.arguments
      else
        flunk "failed to parse: #{example}"
      end
    end
  end
end