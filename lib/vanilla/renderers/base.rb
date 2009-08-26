require 'vanilla/app'
require 'treetop'
require 'vanilla/snip_reference_parser'
require 'vanilla/snip_reference'

module Vanilla
  module Renderers
    class Base
      
      # Render a snip.
      def self.render(snip, part=:content)
        new(app).render(snip, part)
      end
      
      def self.escape_curly_braces(str)
        str.gsub("{", "&#123;").gsub("}", "&#125;")
      end
      
      attr_reader :app
    
      def initialize(app)
        @app = app
      end
      
      def self.snip_regexp
        %r{(\{[^\}.]+\})}
      end
    
      # Default behaviour to include a snip's content
      def include_snips(content)
        content.gsub(Vanilla::Renderers::Base.snip_regexp) do
          snip_tree = parse_snip_reference($1)
          snip_name = snip_tree.snip
          snip_attribute = snip_tree.attribute
          snip_args = snip_tree.arguments
          
          # Render the snip or snip part with the given args, and the current
          # context, but with the default renderer for that snip. We dispatch
          # *back* out to the root Vanilla.render method to do this.
          snip = Vanilla.snip(snip_name)
          if snip
            app.render(snip, snip_attribute, snip_args)
          else
            app.render_missing_snip(snip_name)
          end
        end
      end
      
      def parse_snip_reference(string)
        @parser ||= SnipReferenceParser.new
        @parser.parse(string)
      end
      
      # Default rendering behaviour. Subclasses shouldn't really need to touch this.
      def render(snip, part=:content, args=[])
        prepare(snip, part, args)
        processed_text = render_without_including_snips(snip, part)
        include_snips(processed_text)
      end
      
      # Subclasses should override this to perform any actions required before
      # rendering
      def prepare(snip, part, args)
        # do nothing, by default
      end
      
      def render_without_including_snips(snip, part=:content)
        process_text(raw_content(snip, part))
      end
      
      # Handles processing the text of the content. 
      # Subclasses should override this method to do fancy text processing 
      # like markdown, or loading the content as Ruby code.
      def process_text(content)
        content
      end
      
      # Returns the raw content for the selected part of the selected snip
      def raw_content(snip, part)
        snip.__send__((part || :content).to_sym)
      end
    end
  end
end