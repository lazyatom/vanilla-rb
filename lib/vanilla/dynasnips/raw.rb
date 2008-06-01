require 'vanilla/dynasnip'

class ShowRawContent < Dynasnip
  snip_name "raw"

  usage %|
    Displays the raw contents of a snip in &lt;pre&gt; tags, e.g.
    
      {raw my_snip}
      
    You can specify a part to show, should you wish:
    
      {raw my_snip,specific_part}
  |
  
  def handle(snip_name, part=:content)
    %{<pre>#{Dynasnip.escape_curly_braces(Vanilla.snip(snip_name).__send__(part || :content))}</pre>}
  end
end