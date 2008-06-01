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
  
  def self.persist_all!(overwrite=false)
    all.each do |dynasnip|
      dynasnip.persist!(overwrite)
    end
  end
  
  def self.build_snip
    Snip.new(snip_attributes)
  end
  
  def self.snip_attributes
    full_snip_attributes = {:name => snip_name, :content => self.name, :render_as => "Ruby"}
    @attributes ? full_snip_attributes.merge!(@attributes) : full_snip_attributes
  end
  
  def self.persist!(overwrite=false)
    if overwrite
      snip = Soup[snip_name]
      if snip
        if snip.is_a?(Array)
          snip.each { |s| s.destroy }
        else
          snip.destroy
        end
      end
    end
    snip = Soup[snip_name]
    snip = snip[0] if snip.is_a?(Array)    
    if snip
      snip_attributes.each do |name, value|
        snip.set_value(name, value)
      end
    else
      snip = build_snip
    end
    snip.save
    snip
  end
  
  def method_missing(method, *args)
    if snip = Vanilla.snip(snip_name)
      snip.get_value(method)
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
    Snip[snip_name]
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