class Admin::BaseController < ApplicationController
  include InheritedResources::DSL
  
  layout 'admin'

  before_filter :authenticate_user!, :require_admin!
  

  protected

  def set_locale
    I18n.locale = :en
  end
  
  def require_admin!
    raise "Permission Denied" unless current_user.admin?
  end
end
