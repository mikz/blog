class Admin::SessionsController < ApplicationController
  layout 'login'

  def destroy
    redirect_to destroy_user_session_path
  end

end
