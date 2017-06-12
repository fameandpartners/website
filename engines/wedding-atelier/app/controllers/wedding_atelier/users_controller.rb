require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class UsersController < ApplicationController
    def update
      if try_spree_current_user.update_attribute(:wedding_atelier_signup_step, params[:wedding_atelier_signup_step])
        render json: { status: :ok }
      else
        render json: { errors: try_spree_current_user.errors, status: :unprocessable_entity }
      end
    end
  end
end
