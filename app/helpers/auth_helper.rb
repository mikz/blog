module AuthHelper
  
  def auth_providers(options = {}, url = {:return_to => url_for})
    render "shared/auth_providers", :options => options, :url => url
  end
  
  def auth_img(service, size = nil)
    image_tag auth_img_path(service, size), :alt => service.to_s.gsub("_", " ").capitalize
  end
  
  def auth_img_path(service, size = nil)
     size ||= 32

      service = case service.to_sym
      when :open_id
        :openid
      when :google_apps
        :google
      else 
        service
      end
      
      path_to_image "authbuttons/png/#{service}_#{size}.png"
  end
  
  def auth_provider name, options = {}, url_options = {}
    options = options.symbolize_keys

    options.reverse_merge! :provider => name.downcase, :size => 64, :label => true, :type => :link
    options[:image] ||= options[:provider]
    
    case options[:provider].to_sym
    when :google
      return auth_provider("Google", options.merge({:provider => :open_id, :image => :google}), {:openid_url => "https://www.google.com/accounts/o8/id"}.merge(url_options))
    end

    content = auth_img(options[:image], options[:size])
    content += name if options[:label]
    
    url = user_omniauth_authorize_path(options[:provider], url_options)
    
    case options[:type].to_sym
    when :link
      link_to content, url, :title => name, :class => :auth_provider
    when :submit
      content_tag :button, content, :name => :auth, :value => url, :title => name, :class => :auth_provider
    else
      raise "UnknownType"
    end
    
  end
end