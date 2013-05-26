class CustomDressImagesController < ApplicationController
  before_filter :authenticate_spree_user!
  respond_to :json

  def create
    @custom_dress = CustomDress.find_ghost_for_user_by_id!(current_spree_user.id, params[:custom_dress_id])

    if params[:custom_dress_image][:files]
      @custom_dress_images = []

      params[:custom_dress_image][:files].each do |file|
        custom_dress_image = CustomDressImage.new(:file => file)
        custom_dress_image.custom_dress = @custom_dress

        custom_dress_image.save

        @custom_dress_images << custom_dress_image
      end
    end

    render :json => @custom_dress_images
  end
end
