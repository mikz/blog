module ApplicationHelper
  def title= title
    content_for(:page_title, title)
  end
  
  def author
    Struct.new(:name, :email).new(enki_config[:author][:name], enki_config[:author][:email])
  end
  
  def head_js(*scripts)
    raw "head.js(#{scripts.flatten.reject(&:blank?).map{|src| path_to_javascript(src.to_s).to_json}.join(",")});"
  end
  
  def javascript *scripts
    @javascripts ||= []
    @javascripts.push *scripts.flatten
  end
  
  def javascripts
    @javascripts
  end
  
  def logout_link(return_to = nil)
    link_to t("sign_out"), destroy_user_session_path(:return_to => return_to)
  end
  
  def open_id_delegation_link_tags(server = enki_config[:open_id_delegation, :server], delegate = enki_config[:open_id_delegation, :delegate], xrds = enki_config[:open_id_delegation, :xrds])
    return unless enki_config[:open_id_delegation]
    
    links = []
    
    links << content_tag(:meta, nil, :'http-equiv' => "x-xrds-location", :content => xrds)
    
    links << content_tag(:link, nil, :rel => "openid.server", :href => server)
    links << content_tag(:link, nil, :rel => "openid2.server", :href => server)
    
    links << content_tag(:link, nil, :rel => "openid.delegate", :href => delegate)
    links << content_tag(:link, nil, :rel => "openid2.local_id", :href => delegate)
    
    raw links.join("\n")
  end

  def format_comment_error(error)
    {
      'body'   => 'Please comment',
      'author' => 'Please provide your name or OpenID identity URL',
      'base'   => error.last
    }[error.first.to_s]
  end
end
