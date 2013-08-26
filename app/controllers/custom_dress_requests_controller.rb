class CustomDressRequestsController < ApplicationController
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
end
