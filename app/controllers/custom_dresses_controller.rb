class CustomDressesController < ApplicationController
  layout 'spree/layouts/spree_application'

  def new
    @custom_dress = CustomDress.new
  end

  def create
    if params[:custom_dress][:custom_dress_image_ids].is_a?(Array)
      custom_dress_image_ids = params[:custom_dress].delete(:custom_dress_image_ids)
      custom_dress_image_ids = custom_dress_image_ids.last(5).map(&:to_i)
      custom_dress_image_ids &= session[:custom_dress_image_ids]
    end

    @custom_dress_images = CustomDressImage.where(:id => custom_dress_image_ids)
    @custom_dress = CustomDress.new(params[:custom_dress])
    @custom_dress.custom_dress_images = @custom_dress_images
    if @custom_dress.save
      render :success
    else
      render :new
    end
  end
end
