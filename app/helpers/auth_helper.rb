module AuthHelper
  def auth_img(service, size = nil)
    size ||= 32
    
    service = case service.to_sym
    when :open_id
      :openid
    when :google_apps
      :google
    else 
      service
    end
    image_tag "/images/authbuttons/png/#{service}_#{size}.png", :alt => service.to_s.capitalize
  end
  
  def auth_provider name, options = {}, *args
    options.symbolize_keys!
    options.reverse_merge! :provider => name.downcase, :size => 64, :label => true
    options[:image] ||= options[:provider]
    
    case options[:provider].to_sym
    when :google
      return auth_provider("Google", options.merge({:provider => :open_id, :image => :google}), :openid_url => "https://www.google.com/accounts/o8/id")
    end
    
    content = auth_img(options[:image], options[:size])
    content += name if options[:label]
    link_to content, user_omniauth_authorize_path(options[:provider], *args), :title => name, :class => "auth_provider"
  end
end