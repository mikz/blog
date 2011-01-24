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
  
  
  def label
    %{#{name} (#{email})}
  end
  
  def apply_omniauth(omniauth)
    self.user_info = omniauth['user_info']
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def name
    nickname.presence || full_name.presence || I18n.t(:anonymous)
  end
    
  def password_required?
    false
  end
  
  def email_required?
    true
  end
  
protected

  def user_info= info
    info.symbolize_keys.each_pair do |key, value|
      case key
      when :first_name, :last_name
      when :name
        self.full_name = value
      when :email
        self.email ||= value
      else
        setter = (key.to_s << "=").to_sym
        self.send setter, value if self.respond_to?(setter) && self.send(key).blank?
      end
    end
  end
  
end
