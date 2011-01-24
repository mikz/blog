class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    comment_from_session
  end
  
  private
  def comment_from_session
    begin
      @comment = @post.comments.build(session[:pending_comment])
    rescue
      @comment = @post.comments.build
    ensure
      session[:pending_comment] = nil
    end
  end
end
