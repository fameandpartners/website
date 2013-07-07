class Spree::Admin::Blog::RedCarpetEventsController < Spree::Admin::Blog::BaseController
  respond_to :js, only: :toggle_publish

  def index
    @posts = Blog::Post.page(params[:page]).
             per(params[:per_page] || Spree::Config[:orders_per_page]).red_carpet_posts
  end

  def new
    @blog_post = Blog::Post.new
    @celebrities = Blog::Celebrity.all
    Blog::PostPhoto.where(user_id: current_spree_user.id, post_id: nil).delete_all
  end

  def edit
    @celebrities = Blog::Celebrity.all
    @blog_post = Blog::Post.red_carpet_posts.find(params[:id])
  end

  def create
    attrs = params['blog_post']
    @blog_post              = Blog::Post.new(attrs)
    @blog_post.post_type_id = Blog::Post::PostTypes::RED_CARPET
    @blog_post.user         = current_spree_user
    @blog_post.slug         = slug_from_name(@blog_post.title.to_s) if @blog_post.slug.blank?

    if @blog_post.valid?
      @blog_post.save
      Blog::PostPhoto.where(user_id: current_spree_user.id, post_id: nil).update_all({post_id: @blog_post.id})
      if @blog_post.post_photos.present?
        @blog_post.primary_photo_id = @blog_post.post_photos.first.id
      end
      redirect_to action: :index
    else
      @celebrities = Blog::Celebrity.all
      render action: :new
    end
  end

  def update
    attrs = params['blog_post']
    @blog_post = Blog::Post.red_carpet_posts.find(params[:id])
    @blog_post.assign_attributes(attrs)

    if @blog_post.valid?
      if @blog_post.post_photos.present? && @blog_post.primary_photo.blank?
        @blog_post.primary_photo_id = @blog_post.post_photos.first.id
      end
      @blog_post.save

      redirect_to action: :index
    else
      @celebrities = Blog::Celebrity.all
      render action: :edit
    end
  end

  def toggle_publish
    post = Blog::Post.find(params[:id])
    if post.published?
      post.published_at = nil
    else
      post.published_at = Time.now.utc
    end
    post.save
    respond_to do |format|
      format.js {render text: 'ok' }
    end
  end

  def destroy
    @blog_post = Blog::Post.find(params[:id])
    @blog_post.destroy
    redirect_to action: :index
  end

  private

  def model_class
    Blog::Post
  end

  def slug_from_name(name)
    name.to_s.downcase.gsub(/[^0-9a-z]/, ' ').to_s.gsub(/\s+/, ' ').strip.gsub(' ', '-')
  end

  def update_published_at(post, publish)
    if publish == '1' && post.published_at.blank?
      post.published_at = Time.now.utc
    elsif publish == '0'
      post.published_at = nil
    end
  end

end
