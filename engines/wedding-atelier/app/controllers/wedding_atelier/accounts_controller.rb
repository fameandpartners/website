require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class AccountsController < ApplicationController

    def index
      @user = Spree::User.find(try_spree_current_user.id, select: 'id, first_name, last_name, email, dob, newsletter')
      @orders = @user.orders.complete
      @size_profile = {sizes: Spree::OptionType.size.option_values, heights: WeddingAtelier::Height.definitions}
      @event = @user.events.last
      render :show
    end

    def update
      attrs = params[:account]
      current_password = attrs.delete(:current_password)
      if current_password.present? || attrs[:password].present?
        if !try_spree_current_user.valid_password?(current_password)
          render json: {errors: ['Current password is invalid']}, status: :unprocessable_entity and return
        end
      end
      if try_spree_current_user.update_attributes(attrs)
        sign_in try_spree_current_user, bypass: true if attrs[:password].present?
        render json: {status: :ok}
      else
        render json: {errors: try_spree_current_user.errors}, status: :unprocessable_entity
      end
    end
  end
end
