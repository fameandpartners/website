require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class UsersController < ApplicationController
    def update
      if try_spree_current_user.update_attributes(user_params)
        render json: { status: :ok }
      else
        render json: { errors: try_spree_current_user.errors, status: :unprocessable_entity }
      end
    end

    private
    def user_params
      params[:spree_user]
    end
  end
end
