class Admin::PostsController < Admin::BaseController
  inherit_resources
  defaults :resource_class => Post
  
  respond_to :html, :except => [:preview]
  respond_to :js, :only => [:preview]
  
  before_filter :find_post, :only => [:show, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @posts = Post.paginate(
          :order => "published_at DESC",
          :page  => params[:page]
        )
      }
    end
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'post', :locals => {:post => @post} if request.xhr?
      }
    end
  end
  
  create! do |success, failure|
    failure.html { render :action => 'new', :status => :unprocessable_entity }
  end

  update! do |success, failure|
    failure.html { render :action => 'show', :status => :unprocessable_entity }
  end

  def preview
    @post = Post.build_for_preview(params[:post])

    respond_to do |format|
      format.js {
        render :partial => 'posts/post.html.erb', :locals => {:post => @post}
      }
    end
  end

  def destroy
    undo_item = @post.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted post '#{@post.title}'"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :post         => @post.attributes
        }
      }
    end
  end

  protected

  def find_post
    @post = Post.find(params[:id])
  end
end
