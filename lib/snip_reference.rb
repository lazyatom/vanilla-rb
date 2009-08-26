module SnipReference
  include Treetop::Runtime

  def root
    @root || :snip_call
  end

  module SnipCall0
    def spaces
      elements[0]
    end

    def argument_list
      elements[1]
    end
  end

  module SnipCall1
  end

  def _nt_snip_call
    start_index = index
    if node_cache[:snip_call].has_key?(index)
      cached = node_cache[:snip_call][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("{", index) == index
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("{")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_snip_name
      s0 << r2
      if r2
        i4, s4 = index, []
        r5 = _nt_spaces
        s4 << r5
        if r5
          r6 = _nt_argument_list
          s4 << r6
        end
        if s4.last
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          r4.extend(SnipCall0)
        else
          self.index = i4
          r4 = nil
        end
        if r4
          r3 = r4
        else
          r3 = instantiate_node(SyntaxNode,input, index...index)
        end
        s0 << r3
        if r3
          if input.index("}", index) == index
            r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("}")
            r7 = nil
          end
          s0 << r7
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SnipCall,input, i0...index, s0)
      r0.extend(SnipCall1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:snip_call][start_index] = r0

    return r0
  end

  def _nt_snip_name
    start_index = index
    if node_cache[:snip_name].has_key?(index)
      cached = node_cache[:snip_name][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_word

    node_cache[:snip_name][start_index] = r0

    return r0
  end

  def _nt_argument_list
    start_index = index
    if node_cache[:argument_list].has_key?(index)
      cached = node_cache[:argument_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_hash_pair_list
    if r1
      r0 = r1
    else
      r2 = _nt_word_list
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:argument_list][start_index] = r0

    return r0
  end

  module WordList0
    def argument_separator
      elements[0]
    end

    def word_list
      elements[1]
    end
  end

  module WordList1
    def word
      elements[0]
    end

  end

  def _nt_word_list
    start_index = index
    if node_cache[:word_list].has_key?(index)
      cached = node_cache[:word_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_word
    s0 << r1
    if r1
      i3, s3 = index, []
      r4 = _nt_argument_separator
      s3 << r4
      if r4
        r5 = _nt_word_list
        s3 << r5
      end
      if s3.last
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        r3.extend(WordList0)
      else
        self.index = i3
        r3 = nil
      end
      if r3
        r2 = r3
      else
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(ArgumentList,input, i0...index, s0)
      r0.extend(WordList1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:word_list][start_index] = r0

    return r0
  end

  module HashPairList0
    def argument_separator
      elements[0]
    end

    def hash_pair_list
      elements[1]
    end
  end

  module HashPairList1
    def hash_pair
      elements[0]
    end

  end

  def _nt_hash_pair_list
    start_index = index
    if node_cache[:hash_pair_list].has_key?(index)
      cached = node_cache[:hash_pair_list][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_hash_pair
    s0 << r1
    if r1
      i3, s3 = index, []
      r4 = _nt_argument_separator
      s3 << r4
      if r4
        r5 = _nt_hash_pair_list
        s3 << r5
      end
      if s3.last
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        r3.extend(HashPairList0)
      else
        self.index = i3
        r3 = nil
      end
      if r3
        r2 = r3
      else
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(HashArgumentList,input, i0...index, s0)
      r0.extend(HashPairList1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:hash_pair_list][start_index] = r0

    return r0
  end

  def _nt_argument
    start_index = index
    if node_cache[:argument].has_key?(index)
      cached = node_cache[:argument][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_hash_pair
    if r1
      r0 = r1
    else
      r2 = _nt_word
      r2.extend(NormalArgument)
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:argument][start_index] = r0

    return r0
  end

  module ArgumentSeparator0
    def optional_spaces
      elements[1]
    end
  end

  def _nt_argument_separator
    start_index = index
    if node_cache[:argument_separator].has_key?(index)
      cached = node_cache[:argument_separator][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index(",", index) == index
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(",")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_optional_spaces
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(ArgumentSeparator0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:argument_separator][start_index] = r0

    return r0
  end

  def _nt_hash_pair
    start_index = index
    if node_cache[:hash_pair].has_key?(index)
      cached = node_cache[:hash_pair][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_typical_hash_pair
    if r1
      r0 = r1
    else
      r2 = _nt_new_style_hash_pair
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:hash_pair][start_index] = r0

    return r0
  end

  module TypicalHashPair0
    def word
      elements[0]
    end

    def optional_spaces
      elements[1]
    end

    def optional_spaces
      elements[3]
    end

    def word
      elements[4]
    end
  end

  def _nt_typical_hash_pair
    start_index = index
    if node_cache[:typical_hash_pair].has_key?(index)
      cached = node_cache[:typical_hash_pair][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_word
    s0 << r1
    if r1
      r2 = _nt_optional_spaces
      s0 << r2
      if r2
        if input.index("=>", index) == index
          r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure("=>")
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_optional_spaces
          s0 << r4
          if r4
            r5 = _nt_word
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(TypicalHashArgument,input, i0...index, s0)
      r0.extend(TypicalHashPair0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:typical_hash_pair][start_index] = r0

    return r0
  end

  module NewStyleHashPair0
    def word
      elements[0]
    end

    def word
      elements[2]
    end
  end

  def _nt_new_style_hash_pair
    start_index = index
    if node_cache[:new_style_hash_pair].has_key?(index)
      cached = node_cache[:new_style_hash_pair][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_word
    s0 << r1
    if r1
      if input.index(":", index) == index
        r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(":")
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_word
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(NewStyleHashPair0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:new_style_hash_pair][start_index] = r0

    return r0
  end

  def _nt_word
    start_index = index
    if node_cache[:word].has_key?(index)
      cached = node_cache[:word][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_unquoted_word
    if r1
      r0 = r1
    else
      r2 = _nt_quoted_word
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:word][start_index] = r0

    return r0
  end

  def _nt_unquoted_word
    start_index = index
    if node_cache[:unquoted_word].has_key?(index)
      cached = node_cache[:unquoted_word][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[a-zA-Z0-9_\\-]'), index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:unquoted_word][start_index] = r0

    return r0
  end

  module QuotedWord0
  end

  module QuotedWord1
  end

  def _nt_quoted_word
    start_index = index
    if node_cache[:quoted_word].has_key?(index)
      cached = node_cache[:quoted_word][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if input.index("\"", index) == index
      r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("\"")
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_unquoted_words
      s1 << r3
      if r3
        if input.index("\"", index) == index
          r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("\"")
          r4 = nil
        end
        s1 << r4
      end
    end
    if s1.last
      r1 = instantiate_node(QuotedWord,input, i1...index, s1)
      r1.extend(QuotedWord0)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i5, s5 = index, []
      if input.index("'", index) == index
        r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("'")
        r6 = nil
      end
      s5 << r6
      if r6
        r7 = _nt_unquoted_words
        s5 << r7
        if r7
          if input.index("'", index) == index
            r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("'")
            r8 = nil
          end
          s5 << r8
        end
      end
      if s5.last
        r5 = instantiate_node(QuotedWord,input, i5...index, s5)
        r5.extend(QuotedWord1)
      else
        self.index = i5
        r5 = nil
      end
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:quoted_word][start_index] = r0

    return r0
  end

  def _nt_unquoted_words
    start_index = index
    if node_cache[:unquoted_words].has_key?(index)
      cached = node_cache[:unquoted_words][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[a-zA-Z0-9_\\- ]'), index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:unquoted_words][start_index] = r0

    return r0
  end

  def _nt_optional_spaces
    start_index = index
    if node_cache[:optional_spaces].has_key?(index)
      cached = node_cache[:optional_spaces][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[ ]'), index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:optional_spaces][start_index] = r0

    return r0
  end

  def _nt_spaces
    start_index = index
    if node_cache[:spaces].has_key?(index)
      cached = node_cache[:spaces][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[ ]'), index) == index
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:spaces][start_index] = r0

    return r0
  end

end

class SnipReferenceParser < Treetop::Runtime::CompiledParser
  include SnipReference
end

