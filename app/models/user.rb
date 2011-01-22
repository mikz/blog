class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  #devise :token_authenticatable
  #devise :openid_authenticatable
  devise :omniauthable
  
  has_many :authentications
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me # :email, :password, :password_confirmation, 
  
  
  
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    false
  end
  
  def email_required?
    true
  end
  
  def openid_fields=(fields)
    fields.each do |key, value|
      # Some AX providers can return multiple values per key
      if value.is_a? Array
        value = value.first
      end

      case key.to_s
      when 'nickname', 'http://axschema.org/namePerson/friendly'
        self.nick = value
      when 'fullname', "http://axschema.org/namePerson"
        self.name = value
      when "email", "http://axschema.org/contact/email"
        self.email = value
      when "gender", "http://axschema.org/person/gender"
        self.gender = value
      else
        logger.error "Unknown OpenID field: #{key}"
      end
    end
  end
  
  def self.build_from_identity_url(identity_url)
    User.new(:identity_url => identity_url)
  end
  
  def self.openid_optional_fields
    ['nickname', 'fullname', 'email', "gender", 'http://axschema.org/namePerson/friendly', 'http://axschema.org/namePerson', "http://axschema.org/contact/email", "http://axschema.org/person/gender"]
  end
  
end
