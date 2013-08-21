class CustomDressRequestsController < ApplicationController
  def new
  end

  def create
    info = params.extract!(:first_name, :last_name, :email, :description, :event_date)

    CustomDressesMailer.request_custom_dress(info).deliver

    flash[:notice] = 'Yours enquiry was successfully sent to support team'

    redirect_to custom_dresses_path
  end
end
