class ProductReservationsController < ApplicationController
  respond_to :json

  def create
    if signed_in?
      # create only reservation
      @reservation = spree_current_user.reservations.build(params[:reservation])
      if @reservation.save
        render json: { success: true }
      else
        errors = @reservation.errors.keys
        render json: { success: false, errors: errors }
      end
    else
      # create user too
    end
  end

  private

  def create_reservation
  end
end
