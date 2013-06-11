class Spree::Admin::Blog::RedCarpetEventsController < Spree::Admin::BaseController
  def index
    @red_carpet_events = RedCarpetEvent.all
  end

  def new
    @red_carpet_events = RedCarpetEvent.new
  end

  def create
    @red_carpet_events = RedCarpetEvent.new params[:red_carpet_event]
    @red_carpet_events.user = spree_current_user
    if @red_carpet_events.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @red_carpet_events = RedCarpetEvent.find params[:id]
  end

  def update
    red_carpet_events = RedCarpetEvent.find params[:id]
    if red_carpet_events.update_attributes(params[:red_carpet_event])
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    red_carpet_events = RedCarpetEvent.find(params[:id])
    red_carpet_events.destroy if red_carpet_events.user == spree_current_user && spree_current_user.admin?
  end

  def publish
    post = RedCarpetEvent.find params[:id]
    post.publish!
    redirect_to admin_blog_red_carpet_events_path
  end

  def unpublish
    post = RedCarpetEvent.find params[:id]
    post.unpublish!
    redirect_to admin_blog_red_carpet_events_path
  end

end
