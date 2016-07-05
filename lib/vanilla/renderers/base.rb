require 'vanilla/snip_reference_parser'

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

      def soup
        @app.soup
      end

      def url_to(*args)
        @app.url_to(*args)
      end

      def link_to(link_text, snip_name=link_text, part=nil)
        if soup[snip_name]
          %{<a href="#{url_to(snip_name, part)}">#{link_text}</a>}
        else
          %{<a class="missing" href="#{url_to(snip_name, part)}">#{link_text}</a>}
        end
      end

      def self.snip_regexp
        %r|(\{[\w\-_\d\.\"\' ]+( +[^\}]+)?\})|
      end

      def default_layout_snip
        app.default_layout_snip
      end

      def layout_for(snip)
        layout_snip = (snip && snip.layout) ? soup[snip.layout] : default_layout_snip
      end

      # Default behaviour to include a snip's content
      def include_snips(content, enclosing_snip)
        content.gsub(Vanilla::Renderers::Base.snip_regexp) do
          snip_tree = parse_snip_reference($1)
          if snip_tree
            snip_name = snip_tree.snip
            snip_attribute = snip_tree.attribute
            snip_args = snip_tree.arguments

            # Render the snip or snip part with the given args, and the current
            # context, but with the default renderer for that snip. We dispatch
            # *back* out to the root Vanilla.render method to do this.
            if snip = soup[snip_name]
              app.render(snip, snip_attribute, snip_args, enclosing_snip)
            else
              render_missing_snip(snip_name)
            end
          else
            %|<span class="malformed_snip_inclusion">(malformed snip inclusion: #{self.class.escape_curly_braces($1)})</span>|
          end
        end
      end

      def parse_snip_reference(string)
        @parser ||= Vanilla::SnipReferenceParser.new
        @parser.parse(string)
      rescue Vanilla::SnipReferenceParser::ParseError
        nil
      end

      def render_missing_snip(snip_name)
        "[snip '#{snip_name}' cannot be found]"
      end

      # Default rendering behaviour. Subclasses shouldn't really need to touch this.
      def render(snip, part=:content, args=[], enclosing_snip=snip)
        prepare(snip, part, args, enclosing_snip)
        processed_text = render_without_including_snips(snip, part)
        include_snips(processed_text, snip)
      end

      # Subclasses should override this to perform any actions required before
      # rendering
      def prepare(snip, part, args, enclosing_snip)
        # do nothing, by default
      end

      def render_without_including_snips(snip, part=:content)
        if content = raw_content(snip, part)
          process_text(content)
        else
          app.response.status = 404
          %{Couldn't find part "#{part}" for snip "#{snip.name}"}
        end
      end

      # Handles processing the text of the content.
      # Subclasses should override this method to do fancy text processing
      # like markdown, or loading the content as Ruby code.
      def process_text(content)
        content
      end

      # Returns the raw content for the selected part of the selected snip
      def raw_content(snip, part)
        selected_part = (part || :content).to_sym
        snip.__send__(selected_part) if snip.respond_to?(selected_part)
      end
    end
  end
end
