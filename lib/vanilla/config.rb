require "vanilla"

module Vanilla

  # Create a new Vanilla application
  # Configuration options:
  #
  #  :soup - provide the path to the soup data
  #  :soups - provide an array of paths to soup data
  #  :root - the directory that the soup paths are relative to;
  #          defaults to Dir.pwd
  #  :renderers - a hash of names to classes
  #  :default_renderer - the class to use when no renderer is provided;
  #                      defaults to 'Vanilla::Renderers::Base'
  #  :default_layout_snip - the snip to use as a layout when rendering to HTML;
  #                         defaults to 'layout'
  #  :root_snip - the snip to load for the root ('/') url;
  #               defaults to 'start'
  class Config
    attr_accessor :root,
                  :root_snip,
                  :soups,
                  :renderers,
                  :default_layout_snip,
                  :default_renderer

    def initialize
      @root = Dir.pwd
      @root_snip = "start"
      @soups = ["soups/base", "soups/system"]
      @default_layout_snip = "layout"
      @default_renderer = Vanilla::Renderers::Base
      @renderers = {
        "base" => Vanilla::Renderers::Base,
        "markdown" => Vanilla::Renderers::Markdown,
        "bold" => Vanilla::Renderers::Bold,
        "erb" => Vanilla::Renderers::Erb,
        "rb" => Vanilla::Renderers::Ruby,
        "ruby" => Vanilla::Renderers::Ruby,
        "haml" => Vanilla::Renderers::Haml,
        "raw" => Vanilla::Renderers::Raw,
        "textile" => Vanilla::Renderers::Textile
      }
    end
  end
end