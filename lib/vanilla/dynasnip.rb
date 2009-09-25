require 'vanilla/renderers/base'
require 'enumerator'

class Dynasnip < Vanilla::Renderers::Base
  
  def self.all
    ObjectSpace.enum_for(:each_object, class << self; self; end).to_a - [self]
  end
  
  def self.snip_name(new_name=nil)
    if new_name
      @snip_name = new_name.to_s
    else
      # borrowed from ActiveSupport
      @snip_name ||= self.name.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
  
  def self.attribute(attribute_name, attribute_value=nil)
    @attributes ||= {}
    @attributes[attribute_name.to_sym] = attribute_value if attribute_value
    @attributes[attribute_name.to_sym]
  end
  
  def self.usage(str)
    attribute :usage, escape_curly_braces(str).strip
  end
  
  def self.snip_attributes
    full_snip_attributes = {:name => snip_name, :content => self.name, :render_as => "Ruby"}
    @attributes ? full_snip_attributes.merge!(@attributes) : full_snip_attributes
  end
  
  attr_accessor :enclosing_snip
  
  def method_missing(method, *args)
    if snip
      snip.__send__(method)
    elsif part = self.class.attribute(method)
      part
    else
      super
    end
  end
  
  # dynasnips gain access to the app in the same way as Render::Base
  # subclasses
  
  protected
  
  def snip_name
    self.class.snip_name
  end
  
  def snip
    app.soup[snip_name]
  end
  
  def show_usage
    if snip.usage
      Vanilla::Renderers::Markdown.render(snip_name, :usage)
    else
      "No usage information for #{snip_name}"
    end
  end
  
  def cleaned_params
    p = app.request.params.dup
    p.delete(:snip)
    p.delete(:format)
    p.delete(:method)
    p.delete(:part)
    p
  end
end