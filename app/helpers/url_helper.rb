module UrlHelper
  def post_path(post, options = {})
    suffix = options[:anchor] ? "##{options[:anchor]}" : ""
    path = post.published_at.strftime("/%Y/%m/%d/") + post.slug + suffix
    path = URI.join(enki_config[:url], path) if options[:only_path] == false
    path
  end

  def post_comments_path(post)
    post_path(post) + "/comments"
  end

  def author_link(comment)
    if comment.author
      link_to(comment.author.name, comment.author, :class => 'openid')
    else
      comment.author_name.presence || I18n.t(:anonymous)
    end
  end
end
