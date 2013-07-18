class Blog::SearchesController < BlogBaseController
  POSTS_PER_PAGE = 10
  layout 'spree/layouts/spree_application'
  respond_to :html

  def by_query
    term = params[:q].to_s.downcase.strip
    @posts = Blog::Post.find_by_query(term)
    @posts_count = @posts.count
    @posts = @posts.page(params[:page]).per(POSTS_PER_PAGE)
    respond_to do |format|
      format.js do
      end
      format.html do
        generate_breadcrumbs_for_index
      end
    end
    render :index
  end

  def by_tag
    @posts = Blog::Post.tagged_with(Array.wrap(params[:tag].to_s))
    @posts_count = @posts.count
    @posts = Blog::Post.tagged_with(Array.wrap(params[:tag].to_s)).page(params[:page]).per(POSTS_PER_PAGE)

    generate_breadcrumbs_for_index
    respond_to do |format|
      format.js do
      end
      format.html do
        generate_breadcrumbs_for_index
      end
    end
  	render :index
  end

  private

  def generate_breadcrumbs_for_index
    @breadcrumbs = [[root_path, 'Home'], [request.path, 'Search']]
  end
end
