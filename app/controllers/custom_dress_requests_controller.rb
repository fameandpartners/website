class CustomDressRequestsController < ApplicationController
  before_filter :set_seo_meta

  def new
    @custom_dress = CustomDressRequest.new()
  end

  def create
    @custom_dress = CustomDressRequest.new(params[:custom_dress])
    if @custom_dress.send_request
      flash[:notice] = 'Yours enquiry was successfully sent to support team'
      redirect_to custom_dresses_path
    else
      render action: :new
    end
  end

  private

  def set_seo_meta
    @title = "Custom Dresses Online - Fame & Partners"
  end
end
