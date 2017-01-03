require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class AccountsController < ApplicationController

    def show
      @user = current_spree_user
    end

  end
end
