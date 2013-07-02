class Blog::SearchesController < BlogBaseController
  layout 'spree/layouts/spree_application'
  respond_to :html

  def by_query
    term = params[:q].to_s.downcase.strip
    @posts = Blog::Post.find_by_query(term)
    render :index
  end

  def by_event
    @event = Blog::Event.find_by_slug!(params[:event])
    @posts = @event.posts.includes(:category, :author, :event, :post_photos)
    render :index
  end

  def by_tag
    @posts = Blog::Post.tagged_with(Array.wrap(params[:tag].to_s), match_all: true)
  	render :index
  end

  def by_events
    redirect_to blog_path
  end
end
