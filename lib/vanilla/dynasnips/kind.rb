require 'vanilla/dynasnip'

class Kind < Dynasnip
  def handle(kind, limit=10)
    Soup.sieve(:kind => kind)[0...limit].map do |snip|
      snip_template.gsub('SNIP', app.render(snip))
    end
  end
  
  attribute :snip_template, %{
    <div class="snip">SNIP</div>
  }
end