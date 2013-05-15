class CustomDressImagesController < ApplicationController
  before_filter :authenticate_spree_user!
  respond_to :json

  def create
    if params[:custom_dress_image][:files]
      @custom_dress_images = []

      params[:custom_dress_image][:files].each do |file|
        custom_dress_image = CustomDressImage.new(:file => file)
        if custom_dress_image.save
          session[:custom_dress_image_ids] ||= []
          session[:custom_dress_image_ids] << custom_dress_image.id

          @custom_dress_images << custom_dress_image
        end
      end
    end

    render :json => @custom_dress_images
  end
end
