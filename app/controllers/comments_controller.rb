class CommentsController < ApplicationController
  include UrlHelper
  OPEN_ID_ERRORS = {
    :missing  => "Sorry, the OpenID server couldn't be found",
    :canceled => "OpenID verification was canceled",
    :failed   => "Sorry, the OpenID verification failed" }

  before_filter :find_post, :except => [:new]

  def index
    if request.post?
      create
    else
      redirect_to(post_path(@post))
    end
  end

  def new
    @comment = Comment.build_for_preview(params[:comment])

    respond_to do |format|
      format.js do
        render :partial => 'comment.html.erb', :locals => {:comment => @comment}
      end
    end
  end

  def create
    if auth_path = params.delete(:auth)
      session[:pending_comment] = params[:comment]
      redirect_to auth_path
    else #if user_signed_in? || author = params[:comment].delete(:author_name).presence
      @comment = Comment.new(session[:pending_comment] || params[:comment] || {})
      @comment.post = @post
      @comment.author = current_user

      session[:pending_comment] = nil
      
      if @comment.save
        redirect_to post_path(@post)
      else
        render 'posts/show'
      end
    end
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
  end
end
