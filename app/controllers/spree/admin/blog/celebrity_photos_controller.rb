class Spree::Admin::Blog::CelebrityPhotosController < Spree::Admin::BaseController
  def index
    @celebrity_photos = CelebrityPhoto.all
  end

  def new
    @celebrity_photo = CelebrityPhoto.new
  end

  def create
    @celebrity_photo = CelebrityPhoto.new params[:celebrity_photo]
    @celebrity_photo.user = spree_current_user
    if @celebrity_photo.save
      redirect_to admin_blog_celebrity_photos_path
    else
      render :new
    end
  end

  def edit
    @celebrity_photo = CelebrityPhoto.find params[:id]
  end

  def update
    celebrity_photo = CelebrityPhoto.find params[:id]
    if celebrity_photo.update_attributes(params[:celebrity_photo])
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    celebrity_photo = CelebrityPhoto.find(params[:id])
    celebrity_photo.destroy if celebrity_photo.user == spree_current_user && spree_current_user.admin?
  end
end
