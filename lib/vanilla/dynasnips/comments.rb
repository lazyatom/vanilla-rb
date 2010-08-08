require 'vanilla/dynasnip'
require 'defensio'
require 'date'

class Comments < Dynasnip
  usage %|
    Embed comments within snips!
    
    {comments <false>}
    
    This will embed a list of comments, and a comment form, in a snip
    If the snip is being rendered within another snip, it will show a link to the snip,
    with the number of comments. Add a parameter to disable new comments.
  |

  def get(disable_new_comments=false)
    return usage if self.class.snip_name == app.request.snip_name
    comments = app.soup.with(:commenting_on => enclosing_snip.name)
    comments_html = if app.request.snip_name == enclosing_snip.name
      rendered_comments = render_comments(comments)
      rendered_comments += comment_form.gsub('SNIP_NAME', enclosing_snip.name) unless disable_new_comments
      rendered_comments
    else
     %{<a href="#{url_to(enclosing_snip.name)}">#{comments.length} comments for #{enclosing_snip.name}</a>}
    end
    return comments_html
  end
  
  def post(*args)
    snip_name = app.request.params[:snip]
    existing_comments = app.soup.with(:commenting_on => snip_name)
    comment = app.request.params.reject { |k,v| ![:author, :email, :website, :content].include?(k) }
    
    return "You need to add some details!" if comment.empty?
    
    comment = check_for_spam(comment)
    
    if comment[:spam]
      "Sorry - your comment looks like spam, according to Defensio :("
    else
      return "No spam today, thanks anyway" unless app.request.params[:human] == 'human'
      app.soup << comment.merge({
       :name => "#{snip_name}-comment-#{existing_comments.length + 1}", 
       :commenting_on => snip_name,
       :created_at => Time.now
      })
      "Thanks for your comment! Back to {link_to #{snip_name}}"
    end
  end
  
  def render_comments(comments)
    "<h2>Comments</h2><ol class='comments'>" + comments.map do |comment|
      rendered_comment = comment_template.gsub('COMMENT_CONTENT', app.render(comment)).
                                          gsub('COMMENT_DATE', comment.created_at.to_s)
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
  
  def check_for_spam(comment)
    snip_date = Date.parse(app.soup[app.request.params[:snip]].updated_at)
    Defensio.configure(app.config[:defensio])
    defensio_params = {
      :comment_author_email => comment[:email], 
      :comment_author => comment[:author], 
      :comment_author_url => comment[:website],
      :comment_content => comment[:content],
      :comment_type => "comment", 
      :user_ip => app.request.ip, 
      :article_date => snip_date.strftime("%Y/%m/%d")
    }
    audit = Defensio.audit_comment(defensio_params)
    
    # Augment the comment hash
    comment[:user_ip] = app.request.ip
    comment[:spamminess] = audit["defensio_result"]["spaminess"]
    comment[:spam] = audit["defensio_result"]["spam"]
    comment[:defensio_signature] = audit["defensio_result"]["signature"]
    comment[:defensio_message] = audit["defensio_result"]["message"] if audit["defensio_result"]["message"]
    comment[:defensio_status] = audit["defensio_result"]["status"]
    comment
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
      <label class="human">Type 'human' if you are one: <input type="text" name="human"></input></label>
      <button>Submit</button>
    </form>
  }
end