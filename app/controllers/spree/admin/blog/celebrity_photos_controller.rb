class Spree::Admin::Blog::CelebrityPhotosController < Spree::Admin::Blog::BaseController

  def index
    @celebrity_photos = scope.celebrity_photos.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
  end

  def new
    @blog_celebrity_photo = scope.celebrity_photos.build
    @blog_celebrity_photo.published_at = Time.now.utc
  end

  def edit
    @blog_celebrity_photo = scope.celebrity_photos.find(params[:id])
  end

  def create
    attrs = params['blog_celebrity_photo']
    @blog_celebrity_photo = scope.celebrity_photos.build(attrs)
    @blog_celebrity_photo.user = current_spree_user

    assign_post_and_celebrity(@blog_celebrity_photo, attrs)
    update_published_at(@blog_celebrity_photo, attrs['publish'])

    if @blog_celebrity_photo.valid?
      @blog_celebrity_photo.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    attrs = params['blog_celebrity_photo']
    @blog_celebrity_photo = scope.celebrity_photos.find(params[:id])
    @blog_celebrity_photo.assign_attributes(attrs)

    if attrs['post_slug'].present?
      post = Blog::Post.find_by_slug(attrs['post_slug'])
      if post.present?
        @blog_celebrity_photo.post = post
      end
    end

    assign_post_and_celebrity(@blog_celebrity_photo, attrs)
    update_published_at(@blog_celebrity_photo, attrs['publish'])

    if @blog_celebrity_photo.valid?
      @blog_celebrity_photo.save
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @blog_celebrity_photo = scope.celebrity_photos.find(params[:id])
    @blog_celebrity_photo.destroy
    redirect_to action: :index
  end

  private

  def assign_post_and_celebrity(photo, attrs)
    if attrs['post_slug'].present?
      post = Blog::Post.find_by_slug(attrs['post_slug'])
      if post.present?
        photo.post = post
      end
    end

    if attrs['celebrity_slug'].present?
      celebrity = Blog::Celebrity.find_by_slug(attrs['celebrity_slug'])
      if celebrity.present?
        photo.celebrity = celebrity
      end
    end
  end

  def scope
    @scope ||= if params[:post_id].present?
      @post = Blog::Post.find(params[:post_id])
    elsif params[:celebrity_id]
      @celebrity = Blog::Celebrity.find(params[:celebrity_id])
    end
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

  def model_class
    Blog::CelebrityPhoto
  end
end
