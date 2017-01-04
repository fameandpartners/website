require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class AccountsController < ApplicationController

    def show
      @user = current_spree_user
      @size_profile = {sizes: Spree::OptionType.find_by_name('dress-size').option_values, heights: WeddingAtelier::Height.definitions}
    end

  end
end
