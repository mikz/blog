class Users::AuthenticationsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @authentications = current_user.authentications if current_user
  end
  
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end