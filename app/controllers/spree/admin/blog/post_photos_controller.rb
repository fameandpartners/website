class Spree::Admin::Blog::PostPhotosController < Spree::Admin::Blog::BaseController
  respond_to :json

  def index
    if params[:post_id].blank?
      post_photos = Blog::PostPhoto.where(user_id: current_spree_user.id, post_id: nil)
    else
      post        = Blog::Post.find(params[:post_id])
      post_photos = post.post_photos
    end
    render json: post_photos.map{|upload| upload.to_jq_upload }
  end

  def create
    if params[:post_id].present?
      post = Blog::Post.find(params[:post_id])
      post_photo = post.post_photos.build(photo: (params['blog_post_photo'] || {})['photo'])
    else
      post_photo = Blog::PostPhoto.new(photo: (params['blog_post_photo'] || {})['photo'])
    end
    post_photo.user = current_spree_user
    post_photo.save
    render json: {files: [post_photo.to_jq_upload]}, status: :created
  end

  def destroy
    Blog::PostPhoto.find(params[:id]).destroy
    render json: true
  end

  private

  def model_class
    Blog::PostPhoto
  end
end
