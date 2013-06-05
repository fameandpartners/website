class Spree::Admin::Blog::CelebrityPhotosController < Spree::Admin::BaseController
  def index
    @celebrity_photos = CelebrityPhoto.all
  end

  def new
    @celebrity_photo = CelebrityPhoto.new
  end

  def create
    CelebrityPhoto.create! params[:celebrity_photo]
  end

  def edit
    @celebrity_photo = CelebrityPhoto.find params[:id]
  end

  def update
    celebrity_photo = CelebrityPhoto.find params[:id]
    if celebrity_photo.update_attributes!(params[:celebrity_photo])
      redirect_to :index
    else
      render action: :edit
    end
  end
end
