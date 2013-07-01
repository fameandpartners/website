class Blog::CelebrityPhotosController < BlogBaseController
  def like
    authorize! :like, Blog::CelebrityPhoto
    photo = Blog::CelebrityPhoto.find(params[:id])
    photo.like!(current_spree_user)
    render text: 'ok'
  end

  def dislike
    authorize! :like, Blog::CelebrityPhoto
    photo = Blog::CelebrityPhoto.find(params[:id])
    photo.dislike!(current_spree_user)
    render text: 'ok'
  end
end
