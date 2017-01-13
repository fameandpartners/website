require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class AccountsController < ApplicationController

    def index
      @user = Spree::User.find(try_spree_current_user.id, select: 'id, first_name, last_name, email, dob')
      @orders = @user.orders#.complete.wedding_atelier
      @size_profile = {sizes: Spree::OptionType.find_by_name('dress-size').option_values, heights: WeddingAtelier::Height.definitions}
      render :show
    end

    def update
      if current_spree_user.update_attributes(params[:account])
        render json: {status: :ok}
      else
        render json: {errors: current_spree_users.errors}, status: :unprocessable_entity
      end
    end

    def size_profile
      if current_spree_user.update_attributes(params[:account])
        render json: {status: :ok}
      else
        render json: {errors: current_spree_users.errors}, status: :unprocessable_entity
      end
    end
  end
end
