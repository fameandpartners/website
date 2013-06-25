class Blog::PostsController < BlogBaseController
  before_filter :load_categories
  before_filter :load_featured_celebrities

  def index
    @posts = post_scope.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
  end

  def show
    @post = post_scope.includes(
      :author, :event, :post_photos, :celebrity_photos, :category, :celebrities
    ).find_by_slug!(params[:post_slug])
    generate_breadcrumbs
  end

  private

  def post_scope
    return  @post_scope if @post_scope.present?
    scope = Blog::Post.includes(:author, :category).published
    if params[:type] == 'red_carpet'
      scope = scope.where(post_type_id: Blog::Post::PostTypes::RED_CARPET)
    else
      scope = scope.where(post_type_id: Blog::Post::PostTypes::SIMPLE)
      if params[:category_slug].present?
        category = Blog::Category.find_by_slug(params[:category_slug])
        scope = scope.where(category_id: category.try(:id))
      end
    end
    @post_scope = scope
  end

  def generate_breadcrumbs
    if params[:type] == 'red_carpet'
      @breadcrumbs = [[root_path, 'Home'], [blog_red_carpet_posts_path, 'Red Carpet Events'], [blog_red_carpet_post_path(@post.slug), @post.title]]
    else
      @breadcrumbs = [[root_path, 'Home'], [blog_posts_by_category_path(@post.category.slug), @post.category.name], [blog_red_carpet_post_path(@post.slug), @post.title]]
    end
  end
  helper_method :bread_crumbs
end
