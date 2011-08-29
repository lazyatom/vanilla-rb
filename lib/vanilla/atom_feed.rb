require "atom"

module Vanilla
  class AtomFeed
    attr_reader :domain, :app, :title

    def initialize(params={})
      @domain = params[:domain] || "yourdomain.example.com"
      @title = params[:title] || domain
      @app = params[:app]
      @criteria = params[:matching]
      @snips = params[:snips]
      if @snips.nil?
        if @criteria.nil?
          @snips = app.soup.all_snips
        else
          @snips = app.soup[@criteria]
        end
      end
    end

    def to_s
      Atom::Feed.new do |f|
        f.title = title
        f.updated = most_recent_updated_at
        f.id = "tag:x,2008-06-01:kind/x"
        f.entries = entries
      end.to_xml
    end

    private

    def snips
      @snips.sort_by { |s| atom_time(s.updated_at) }.reverse
    end

    def most_recent_updated_at
      if snips.first
        atom_time(snips.first.updated_at)
      else
        atom_time(nil)
      end
    end

    def entries
      snips.map do |snip|
        Atom::Entry.new do |e|
          e.published = atom_time(snip.created_at)
          e.updated = atom_time(snip.updated_at || snip.created_at)
          e.content = Atom::Content::Html.new(externalise_links(app.render(snip)))
          e.title = snip.title || snip.name
          e.authors = [Atom::Person.new(:name => snip.author || domain)]
          e.links << Atom::Link.new(:href => "http://#{domain}#{app.url_to(snip.name)}")
          e.id = "tag:#{domain},#{atom_time(snip.created_at || Time.now).split("T")[0]}:/#{snip.name}"
        end
      end
    end

    def atom_time(time)
      return Time.at(0) if time.nil?
      time = Time.parse(time) unless time.respond_to?(:strftime)
      time.strftime("%Y-%m-%dT%H:%M:%S%z").insert(-3, ":")
    end

    def externalise_links(content)
      content.gsub(/href=(["'])\//, "href=\\1http://#{domain}/").gsub(/src=(["'])\//, "src=\\1http://#{domain}/")
    end
  end
end