class ProductReservationsController < ApplicationController
  respond_to :json

  def create
    user = try_spree_current_user
    if user.blank?
      user = Spree::User.new(params[:user])
      if user.save
        sign_in(:spree_user, user)
      else
        errors = user.errors.messages
        render json: { success: false, errors: errors }
        return
      end
    end

    reservation = user.reservations.build(params[:reservation])
    if reservation.save
      render json: { success: true, user: serialize_user(user) }
    else
      errors = reservation.errors.messages
      render json: { success: false, errors: errors, user: serialize_user(user) }
    end
  end
end
