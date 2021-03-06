require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CommentsController do
  describe 'handling GET to index' do
    before(:each) do
      @posts = [mock_model(Comment), mock_model(Comment)]
      Comment.stub!(:paginate).and_return(@comments)
      login_admin
      get :index
    end

    it("is successful")               { should respond_with(:success) }
    it("renders index template")      { should render_template('index') }
    it("finds comments for the view") { assigns[:comments].should == @comments }
  end

  describe 'handling GET to show' do
    before(:each) do
      @comment = Comment.new
      Comment.stub!(:find).and_return(@comment)
      login_admin
      get :show, :id => 1
    end

    it("is successful")              { should respond_with(:success) }
    it("renders show template")      { should render_template('show') }
    it("finds comment for the view") { assigns[:comment].should == @comment }
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @comment = mock_model(Comment, :author => 'Don Alias')
      @comment.stub!(:update_attributes).and_return(true)
      Comment.stub!(:find).and_return(@comment)

      @attributes = {'body' => 'a comment'}
    end

    def do_put
      login_admin
      put :update, :id => 1, :comment => @attributes
    end

    it("redirects to index") do
      do_put
      response.should be_redirect
      response.should redirect_to(admin_comments_path)
    end

    it("updates comment") do
      @comment.should_receive(:update_attributes).with(@attributes).and_return(true)
      do_put
    end

    it("puts a message in the flash") do
      do_put
      flash[:notice].should_not be_blank
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @comment = mock_model(Comment, :author => 'Don Alias')
      @comment.stub!(:update_attributes).and_return(false)
      Comment.stub!(:find).and_return(@comment)

      @attributes = {:body => ''}
    end

    def do_put
      login_admin
      put :update, :id => 1, :comment => @attributes
    end

    it("renders show") do
      do_put
      should render_template('show')
    end

    it("assigns comment for the view") do
      do_put
      assigns(:comment).should == @comment
    end
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      @comment = Comment.new
      @comment.stub!(:destroy)
      Comment.stub!(:find).and_return(@comment)
    end

    def do_delete
      login_admin
      delete :destroy, :id => 1
    end

    it("redirects to index") do
      do_delete
      response.should be_redirect
      response.should redirect_to(admin_comments_path)
    end

    it("deletes comment") do
      @comment.should_receive(:destroy)
      do_delete
    end
  end

  describe 'handling DELETE to destroy, JSON request' do
    before(:each) do
      @comment = Comment.new(:author => 'xavier')
      @comment.stub!(:destroy_with_undo).and_return(mock("undo_item", :description => 'hello'))
      Comment.stub!(:find).and_return(@comment)
    end

    def do_delete
      login_admin
      delete :destroy, :id => 1, :format => 'json'
    end

    it("deletes comment") do
      @comment.should_receive(:destroy_with_undo).and_return(mock("undo_item", :description => 'hello'))
      do_delete
    end

    it("renders json including a description of the comment") do
      do_delete
      JSON.parse(response.body)['undo_message'].should == 'hello'
    end
  end
end
