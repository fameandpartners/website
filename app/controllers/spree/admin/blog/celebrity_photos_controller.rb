class Spree::Admin::Blog::CelebrityPhotosController < Spree::Admin::Blog::BaseController
  respond_to :json

  def index
    if params[:post_id].blank? && params[:celebrity_id].blank?
      post_photos = Blog::CelebrityPhoto.includes(:celebrity).where(user_id: current_spree_user.id, post_id: nil, celebrity_id: nil)
    elsif params[:post_id].present?
      post        = Blog::Post.find(params[:post_id])
      photos      = post.celebrity_photos.includes(:celebrity)
    elsif params[:celebrity_id].present?
      celebrity   = Blog::Celebrity.find(params[:celebrity_id])
      photos      = celebrity.celebrity_photos
    end
    render json: photos.map{|upload| upload.to_jq_upload }
  end

  def create
    photos = Array.wrap((params['blog_celebrity_photo'] || {})['photo']).map do |photo_attrs|
      if params[:post_id].present?
        post = Blog::Post.find(params[:post_id])
        photo = post.celebrity_photos.build(photo: photo_attrs)
      elsif params[:celebrity_id].present?
        celebrity = Blog::Celebrity.find(params[:celebrity_id])
        photo = celebrity.celebrity_photos.build(photo: photo_attrs)
      else
        photo = Blog::CelebrityPhoto.new(photo: photo_attrs)
      end
      photo.user = current_spree_user
      photo.save
      photo
    end
    render json: {files: photos.map {|p| p.to_jq_upload}}, status: :created
  end

  def destroy
    Blog::CelebrityPhoto.find(params[:id]).destroy
    render json: true
  end

  def assign_celebrity
    celebrity = Blog::Celebrity.find(params[:celebrity_id])
    photo = Blog::CelebrityPhoto.find(params[:id])
    photo.celebrity = celebrity
    photo.save
    head :ok
  end

  private

  def model_class
    Blog::CelebrityPhoto
  end
end
