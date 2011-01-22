class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  protected

  def enki_config
    @@enki_config = Enki::Config.default
  end
  
  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end
  
  helper_method :enki_config
end
