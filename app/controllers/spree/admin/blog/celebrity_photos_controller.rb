class Spree::Admin::Blog::CelebrityPhotosController < Spree::Admin::Blog::BaseController
  respond_to :json

  def index
    if params[:post_id].blank?
      post_photos = Blog::CelebrityPhoto.includes(:celebrity).where(user_id: current_spree_user.id, post_id: nil)
    else
      post        = Blog::Post.find(params[:post_id])
      photos      = post.celebrity_photos.includes(:celebrity)
    end
    render json: photos.map{|upload| upload.to_jq_upload }
  end

  def create
    if params[:post_id].present?
      post = Blog::Post.find(params[:post_id])
      post_photo = post.celebrity_photos.build(photo: (params['blog_celebrity_photo'] || {})['photo'])
    else
      post_photo = Blog::CelebrityPhoto.new(photo: (params['blog_celebrity_photo'] || {})['photo'])
    end
    post_photo.user = current_spree_user
    post_photo.save
    render json: {files: [post_photo.to_jq_upload]}, status: :created
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
