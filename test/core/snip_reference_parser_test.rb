require "test_helper"

context "The SnipReference parser" do

  setup do
    @parser = Vanilla::SnipReferenceParser.new
  end

  examples = {
    :snip_names => {
      %|{snip}|                  => {:snip => 'snip', :attribute => nil, :arguments => []},
      %|{Snip}|                  => {:snip => 'Snip', :attribute => nil, :arguments => []},
      %|{123snip}|               => {:snip => '123snip', :attribute => nil, :arguments => []},
      %|{Snip123}|               => {:snip => 'Snip123', :attribute => nil, :arguments => []},
      %|{snip-with-dashes}|      => {:snip => 'snip-with-dashes', :attribute => nil, :arguments => []},
      %|{snip_with_underscores}| => {:snip => 'snip_with_underscores', :attribute => nil, :arguments => []},
    },

    :snip_attributes => {
      %|{snip.snip_attribute}|     => {:snip => 'snip', :attribute => 'snip_attribute', :arguments => []},
      %|{snip.snip_attribute arg}| => {:snip => 'snip', :attribute => 'snip_attribute', :arguments => ['arg']},
      %|{snip."spaced attribute"}| => {:snip => 'snip', :attribute => 'spaced attribute', :arguments => []},
      %|{snip.'spaced attribute'}| => {:snip => 'snip', :attribute => 'spaced attribute', :arguments => []}
    },

    :simple_arguments => {
      %|{snip argument}|           => {:snip => 'snip', :attribute => nil, :arguments => ["argument"]},
      %|{snip1 argument}|          => {:snip => 'snip1', :attribute => nil, :arguments => ["argument"]},
      %|{snip arg-dashes}|         => {:snip => 'snip', :attribute => nil, :arguments => ["arg-dashes"]},
      %|{snip arg_underscores}|    => {:snip => 'snip', :attribute => nil, :arguments => ["arg_underscores"]},
      %|{snip arg1,arg2}|          => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', 'arg2']},
      %|{snip arg1, arg2}|         => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', 'arg2']},
      %|{snip arg1,  arg2}|        => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', 'arg2']},
      %|{snip 1ARG, arg_2, arg-3}| => {:snip => 'snip', :attribute => nil, :arguments => ['1ARG', 'arg_2', 'arg-3']}
    },

    :snip_name_spaces => {
      %|{"snip with spaces"}|           => {:snip => 'snip with spaces', :attribute => nil, :arguments => []},
      %|{'snip with spaces'}|           => {:snip => 'snip with spaces', :attribute => nil, :arguments => []},
      %|{"snip with spaces" argument}|  => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['argument']},
      %|{'snip with spaces' argument}|  => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['argument']},
      %|{"snip with spaces" a, b}|      => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['a', 'b']},
      %|{'snip with spaces' a, b}|      => {:snip => 'snip with spaces', :attribute => nil, :arguments => ['a', 'b']},
      %|{"snip with spaces".attribute}| => {:snip => 'snip with spaces', :attribute => 'attribute', :arguments => []},
      %|{'snip with spaces'.attribute}| => {:snip => 'snip with spaces', :attribute => 'attribute', :arguments => []}
    },

    :arguments_with_spaces => {
      %|{snip arg spaces}|           => {:snip => 'snip', :attribute => nil, :arguments => ['arg spaces']},
      %|{snip arg spaces, and this}| => {:snip => 'snip', :attribute => nil, :arguments => ['arg spaces', 'and this']},
      %|{snip "arg spaces"}|         => {:snip => 'snip', :attribute => nil, :arguments => ['arg spaces']},
      %|{snip 'arg spaces'}|         => {:snip => 'snip', :attribute => nil, :arguments => ['arg spaces']},
      %|{snip "arg spaces", arg2}|   => {:snip => 'snip', :attribute => nil, :arguments => ['arg spaces', 'arg2']}
    },

    :nil_arguments => {
      %|{snip arg1,nil,arg3}|   => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', nil, 'arg3']},
      %|{snip arg1, nil ,arg3}| => {:snip => 'snip', :attribute => nil, :arguments => ['arg1', nil, 'arg3']}
    },

    :classic_ruby_hash_arguments => {
      %|{s key1=>value1, key2 => value2}|     => {:snip => 's', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
      %|{s key1 => value1, key2 => value2}|   => {:snip => 's', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
      %|{s :key1 => value1, :key2 => value2}| => {:snip => 's', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
      %|{s key1 => "value with spaces"}|      => {:snip => 's', :arguments => {:key1 => "value with spaces"}},
      %|{s.attr key1=>value1}|                => {:snip => 's', :attribute => 'attr', :arguments => {:key1 => 'value1'}},
      %|{s "key with spaces" => value}|       => {:snip => 's', :arguments => {:"key with spaces" => "value"}}
    },

    :named_arguments => {
      %|{s key1:value1,key2:value2}|    => {:snip => 's', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
      %|{s key1:value1, key2:value2}|   => {:snip => 's', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
      %|{s key1: value1, key2: value2}| => {:snip => 's', :arguments => {:key1 => 'value1', :key2 => 'value2'}},
      %|{s key1:"value with spaces"}|   => {:snip => 's', :arguments => {:key1 => 'value with spaces'}}
    },

    :quoting_arguments => {
      # %|{s "arg \\" double"}| => {:snip => 's', :attribute => nil, :arguments => ['arg " double']},
      # %|{s 'arg \\' single'}| => {:snip => 's', :attribute => nil, :arguments => ["arg ' single"]},
      %|{s "arg ' single"}|   => {:snip => 's', :attribute => nil, :arguments => ["arg ' single"]},
      %|{s 'arg " double'}|   => {:snip => 's', :attribute => nil, :arguments => ['arg " double']},
      %|{s "arg, comma"}|     => {:snip => 's', :attribute => nil, :arguments => ['arg, comma']},
      %|{s 'arg, comma'}|     => {:snip => 's', :attribute => nil, :arguments => ['arg, comma']},
      # %|{s "arg { open"}|     => {:snip => 's', :attribute => nil, :arguments => ['arg { open']},
      # %|{s "arg } close"}|    => {:snip => 's', :attribute => nil, :arguments => ['arg } close']}
    }
  }

  examples.each do |type, set|
    context type.to_s.gsub("_", " ") do
      set.each do |example, expected|
        should "parse '#{example}' into #{expected.inspect}" do
          reference = @parser.parse(example)
          if reference
            assert_equal expected[:snip],      reference.snip
            assert_equal expected[:attribute], reference.attribute
            assert_equal expected[:arguments], reference.arguments
            assert_parsable_by_vanilla example, expected
          else
            flunk "failed to parse: #{example} - #{@parser.failure_reason}"
          end
        end
      end
    end
  end

  private

  def assert_parsable_by_vanilla(example, expected)
    create_snip_from_expected expected
    create_snip :name => "test", :content => "alpha #{example} beta"
    assert_response_body "alpha ok beta", "/test"
  end

  def create_snip_from_expected(expected)
    simple_dyna = %|class SimpleDyna;def handle(*args); 'ok'; end;self;end|
    attributes = {:name => expected[:snip], :content => simple_dyna, :render_as => "ruby"}
    if expected[:attribute]
      attributes[expected[:attribute]] = simple_dyna
    end
    create_snip(attributes)
  end
end