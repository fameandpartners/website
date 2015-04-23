class Blog::PostsController < BlogBaseController
  POSTS_PER_PAGE = 10

  before_filter :load_categories
  before_filter :load_featured_celebrities

  def index
    @posts_count = post_scope.count
    @posts = post_scope.page(params[:page]).per(POSTS_PER_PAGE)

    if params[:type] == 'red_carpet'
      title 'Red carpet events'
      description 'Red carpet events'
    elsif @category.present?
      title "Posts in #{@category.name}"
      description "Posts in #{@category.name}"
    else
      title "Blog"
      description "Blog"
    end

    respond_to do |format|
      format.js do
      end
      format.html do
        generate_breadcrumbs_for_index
      end
    end
  end

  def show
    @post = post_scope.includes(
      :user, :post_photos, :celebrity_photos, :category, :celebrities
    ).find_by_slug(params[:post_slug])

    if @post.blank?
      if params[:category_slug] and (category = Blog::Category.find_by_slug(params[:category_slug]))
        redirect_to blog_posts_by_category_path(category_slug: category.slug) and return
      else
        redirect_to(blog_path) and return
      end
    end

    if params[:type] == 'red_carpet'
      title "#{@post.title} in Events"
      description "#{@post.title}. #{view_context.truncate(@post.body, :length => 200)}"
    elsif @category.present?
      title "#{@post.title} in #{@category.name}"
      description "#{@post.title}. #{view_context.truncate(@post.body, :length => 200)}"
    end

    @recommended_posts = []
    if @post.category.present?
      @recommended_posts = @post.category.posts.published.simple_posts.limit(3).where("id != ?", @post.id).includes(:post_photos, :category)
    end
    @recommended_dresses = Spree::Product.featured.limit(4)
    generate_breadcrumbs_for_show
  end

  private

  def post_scope
    return  @post_scope if @post_scope.present?
    scope = Blog::Post.includes(:author, :category)

    if params[:type] == 'red_carpet'
      scope = scope.red_carpet_posts
    else
      unless try_spree_current_user.try(:blog_moderator?) && params[:action].eql?('show')
        scope = scope.published
      end
      scope = scope.where(post_type_id: Blog::Post::PostTypes::SIMPLE)
      if params[:category_slug].present?
        @category = Blog::Category.find_by_slug(params[:category_slug])
        if @category.present?
          scope = scope.where(category_id: @category.try(:id))
        end
      end
    end
    @post_scope = scope
  end

  def generate_breadcrumbs_for_show
    if params[:type] == 'red_carpet'
      @breadcrumbs = [[blog_path, 'Home'], [blog_red_carpet_posts_path, 'Red Carpet Events'], [blog_red_carpet_post_path(@post.slug), @post.title]]
    else
      @breadcrumbs = [[blog_path, 'Home'], [blog_posts_by_category_path(@post.category.slug), @post.category.name], [blog_post_by_category_path(@post.category.slug, @post.slug), @post.title]]
    end
  end

  def generate_breadcrumbs_for_index
    if params[:type] == 'red_carpet'
      @breadcrumbs = [[blog_path, 'Home'], [blog_red_carpet_posts_path, 'Red Carpet Events']]
    elsif @category.present?
      @breadcrumbs = [[blog_path, 'Home'], [blog_posts_by_category_path(@category.try(:slug)), @category.try(:name)]]
    else
      @breadcrumbs = [[blog_path, 'Home']]
    end
  end
end
