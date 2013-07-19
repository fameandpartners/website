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
    post = nil
    photos = Array.wrap((params['blog_post_photo'] || {})['photo']).map do |photo_attrs|
      if params[:post_id].present?
        post = Blog::Post.find(params[:post_id])
        post_photo = post.post_photos.build(photo: photo_attrs)
      else
        post_photo = Blog::PostPhoto.new(photo: photo_attrs)
      end

      post_photo.user = current_spree_user
      post_photo.save
      post_photo
    end

    if post.present?
      if post.post_photos.present? && post.primary_photo.blank?
        post.primary_photo_id = post.post_photos.first.id
      end
      post.save
    end

    render json: {files: photos.map {|post_photo| post_photo.to_jq_upload}}, status: :created
  end

  def destroy
    post_photo = Blog::PostPhoto.find(params[:id])
    post = post_photo.post
    if post.present?
      post_photo.destroy
      if post.primary_photo.blank? && post.post_photos.present?
        post.primary_photo = post.post_photos.first
        post.save
      end
    end
    render json: true
  end

  private

  def model_class
    Blog::PostPhoto
  end
end
