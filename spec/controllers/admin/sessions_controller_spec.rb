require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionsController do

  describe 'handling DELETE to destroy' do
    before(:each) do
      delete :destroy
    end

    it 'redirects to /' do
      should respond_with(:redirect)
      should redirect_to(destroy_user_session_path)
    end
  end

end

shared_examples_for "logged in and redirected to /admin" do
  it "should set session[:logged_in]" do
    session[:logged_in].should be_true
  end
  it "should redirect to admin posts" do
    response.should be_redirect
    response.should redirect_to('/admin')
  end
end

shared_examples_for "not logged in" do
  it "should not set session[:logged_in]" do
    session[:logged_in].should be_nil
  end
  it "should render new" do
    should respond_with(:success)
    should render_template("new")
  end
  it "should set flash.now[:error]" do
    flash.now[:error].should_not be_nil
  end
end

