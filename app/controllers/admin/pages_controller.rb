class Admin::PagesController < Admin::BaseController
  inherit_resources
  
  before_filter :find_page, :only => [:show, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @pages = Page.paginate(
          :order => "created_at DESC",
          :page  => params[:page]
        )
      }
    end
  end

  create! do |success, failure|
    failure.html { render :action => 'new', :status => :unprocessable_entity }
  end

  update! do |success, failure|
    failure.html { render :action => 'show', :status => :unprocessable_entity }
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'page', :locals => {:page => @page} if request.xhr?
      }
    end
  end

  def preview
    @page = Page.build_for_preview(params[:page])

    respond_to do |format|
      format.js {
        render :partial => 'pages/page.html.erb', :locals => {:page => @page}
      }
    end
  end

  def destroy
    undo_item = @page.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted page '#{@page.title}'"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :page         => @page.attributes
        }.to_json
      }
    end
  end

  protected

  def find_page
    @page = Page.find(params[:id])
  end
end
