class Blog::CelebrityPhotosController < BlogBaseController
  before_filter :authenticate_spree_user!

  def like
    photo = Blog::CelebrityPhoto.find(params[:id])
    photo.like!(current_spree_user)
    head :ok
  end

  def dislike
    photo = Blog::CelebrityPhoto.find(params[:id])
    photo.dislike!(current_spree_user)
    head :ok
  end
end
