require 'vanilla/dynasnip'

class Comments < Dynasnip
  usage %|
    Embed comments within snips!
    
    {comments <snip-name>}
    
    This will embed a list of comments, and a comment form, in a snip
    If the snip is being rendered within another snip, it will show a link to the snip,
    with the number of comments.
  |

  def get(snip_name=nil?)
    snip_name = snip_name || app.request.params[:snip]
    return usage if self.class.snip_name == snip_name
    comments = Soup.sieve(:commenting_on => snip_name)
    comments_html = if app.request.snip_name == snip_name
      render_comments(comments) + comment_form.gsub('SNIP_NAME', snip_name)
    else
     %{<a href="#{Vanilla::Routes.url_to(snip_name)}">#{comments.length} comments for #{snip_name}</a>}
    end
    return comments_html
  end
  
  def post(*args)
    snip_name = app.request.params[:snip]
    existing_comments = Soup.sieve(:commenting_on => snip_name)
    comment = app.request.params.reject { |k,v| ![:author, :email, :website, :content].include?(k) }
    return "You need to add some details!" if comment.empty?
    Soup << comment.merge({
     :name => "#{snip_name}-comment-#{existing_comments.length + 1}", 
     :commenting_on => snip_name,
     :created_at => Time.now
    })
    "Thanks for your comment! Back to {link_to #{snip_name}}"
  end
  
  def render_comments(comments)
    "<h2>Comments</h2><ol class='comments'>" + comments.map do |comment|
      rendered_comment = comment_template.gsub('COMMENT_CONTENT', app.render(comment)).
                                          gsub('COMMENT_DATE', comment.created_at)
      author = comment.author
      author = "Anonymous" unless author && author != ""
      if comment.website && comment.website != ""
        rendered_comment.gsub!('COMMENT_AUTHOR', "<a href=\"#{comment.website}\">#{author}</a>")
      else
        rendered_comment.gsub!('COMMENT_AUTHOR', author)
      end
      rendered_comment
    end.join + "</ol>"    
  end
  
  attribute :comment_template, %{
    <li>
      <p>COMMENT_AUTHOR (COMMENT_DATE)</p>
      <div>COMMENT_CONTENT</div>
    </li>
  }
  
  attribute :comment_form, %{
    <form class="comments" action="/#{snip_name}?snip=SNIP_NAME" method="POST">
      <label>Name: <input type="text" name="author"></input></label>
      <label>Email: <input type="text" name="email"></input></label>
      <label>Website: <input type="text" name="website"></input></label>
      <textarea name="content"></textarea>
      <button>Submit</button>
    </form>
  }
end