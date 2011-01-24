require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HealthController do
  describe 'handling GET to index' do
    before(:each) do
      login_admin
      get :index
    end

    it("is successful"){ should respond_with(:success) }
    it("renders health template"){ should render_template("index") }

  end

  describe 'handling POST to generate_exception' do
    describe 'when logged in' do
      it 'raises a RuntimeError' do
        login_admin
        lambda {
          post :generate_exception
        }.should raise_error
      end
    end

    describe 'when not logged in' do
      it 'does not raise' do
        lambda {
          post :generate_exception
        }.should_not raise_error
      end
    end
  end

  describe 'handling GET to generate_exception' do
    it '405s' do
      login_admin
      get :generate_exception
      response.status.should == 405
      response.headers['Allow'].should == 'POST'
    end
  end
end
