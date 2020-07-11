require 'vanilla/renderers/base'
require 'enumerator'

module Vanilla
  class Dynasnip < Vanilla::Renderers::Base

    def self.all
      ObjectSpace.enum_for(:each_object, class << self; self; end).to_a - [self]
    end

    def self.attribute(attribute_name, attribute_value=nil)
      @attributes ||= {}
      @attributes[attribute_name.to_sym] = attribute_value if attribute_value
      @attributes[attribute_name.to_sym]
    end

    def self.default_snip_name
      # borrowed from ActiveSupport
      self.name.
        split("::").last.
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def self.snip_name(new_name=nil)
      if new_name.nil?
        if name = attribute(:snip_name)
          name
        else
          name = default_snip_name
          attribute :snip_name, name
          name
        end
      else
        attribute :snip_name, new_name
        new_name
      end
    end

    def self.usage(str=nil)
      attribute :usage, str
    end

    def self.snip_attributes
      full_snip_attributes = {name: snip_name, content: self.name, render_as: "Ruby"}
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

    def requesting_this_snip?
      app.request.snip_name == snip_name
    end

    def snip_name
      self.class.snip_name
    end

    def usage
      str = self.class.attribute(:usage)
      self.class.escape_curly_braces(str).strip if str
    end

    def snip
      app.soup[snip_name]
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
end
