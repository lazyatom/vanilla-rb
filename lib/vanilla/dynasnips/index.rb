require 'vanilla/dynasnip'

class Index < Dynasnip
  def get(*args)
    # TODO: figure out a way around calling Soup/AR methods directly.
    list = Soup.tuple_class.find_all_by_name('name', :order => 'updated_at DESC').map { |tuple| 
      "<li>#{Vanilla::Routes.link_to tuple.value}</li>"
    }
    "<ol>#{list}</ol>"
  end
end