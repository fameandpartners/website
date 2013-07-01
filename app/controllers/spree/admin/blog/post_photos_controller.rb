class Spree::Admin::Blog::PostPhotosController < Spree::Admin::Blog::BaseController

  def index
    @post        = Blog::Post.find(params[:post_id])
    @post_photos = @post.post_photos.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
  end

  def new
    @post            = Blog::Post.find(params[:post_id])
    @blog_post_photo = @post.post_photos.build
  end

  def edit
    @post            = Blog::Post.find(params[:post_id])
    @blog_post_photo = @post.post_photos.find(params[:id])
  end

  def create
    attrs = params['blog_post_photo']
    @post = Blog::Post.find(params[:post_id])
    @blog_post_photo = @post.post_photos.build(attrs)
    @blog_post_photo.user = current_spree_user

    if @blog_post_photo.valid?
      @blog_post_photo.save
      if attrs['primary'] == '1'
        @post.primary_photo_id = @blog_post_photo.id
        @post.save
      end
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    attrs = params['blog_post_photo']
    @post = Blog::Post.find(params[:post_id])
    @blog_post_photo = @post.post_photos.find(params[:id])
    @blog_post_photo.assign_attributes(attrs)

    if @blog_post_photo.valid?
      @blog_post_photo.save
      if attrs['primary'] == '1'
        @post.primary_photo_id = @blog_post_photo.id
        @post.save
      end
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @post = Blog::Post.find(params[:post_id])
    @blog_post_photo = @post.post_photos.find(params[:id])
    @blog_post_photo.destroy
    redirect_to action: :index
  end

  private

  def model_class
    Blog::PostPhoto
  end
end
