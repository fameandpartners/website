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
    elsif params[:category_slug].present?
      title "Posts in #{@category.name}"
      description "Posts in #{@category.name}"
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
    ).find_by_slug!(params[:post_slug])

    if params[:type] == 'red_carpet'
      title "#{@post.title} in Events"
      description "#{@post.title}. #{view_context.truncate(@post.body, :length => 200)}"
    elsif params[:category_slug].present?
      title "#{@post.title} in #{@category.name}"
      description "#{@post.title}. #{view_context.truncate(@post.body, :length => 200)}"
    end

    if current_spree_user.present?
      @photo_votes = Blog::CelebrityPhotoVote.where(
        user_id: current_spree_user.id, celebrity_photo_id: @post.celebrity_photos.map(&:id)
      )
    end
    generate_breadcrumbs_for_show
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
        @category = Blog::Category.find_by_slug(params[:category_slug])
        scope = scope.where(category_id: @category.try(:id))
      end
    end
    @post_scope = scope
  end

  def generate_breadcrumbs_for_show
    if params[:type] == 'red_carpet'
      @breadcrumbs = [[root_path, 'Home'], [blog_red_carpet_posts_path, 'Red Carpet Events'], [blog_red_carpet_post_path(@post.slug), @post.title]]
    else
      @breadcrumbs = [[root_path, 'Home'], [blog_posts_by_category_path(@post.category.slug), @post.category.name], [blog_post_by_category_path(@post.category.slug, @post.slug), @post.title]]
    end
  end

  def generate_breadcrumbs_for_index
    if params[:type] == 'red_carpet'
      @breadcrumbs = [[root_path, 'Home'], [blog_red_carpet_posts_path, 'Red Carpet Events']]
    else
      @breadcrumbs = [[root_path, 'Home'], [blog_posts_by_category_path(@category.try(:slug)), @category.try(:name)]]
    end
  end
end
