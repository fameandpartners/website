require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class AccountsController < ApplicationController

    def show
      @user = current_spree_user
      @tabs = ['My Orders', 'Account Details', 'My Size Profile']
    end

  end
end
