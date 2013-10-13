module Personalization
  class BaseController < ApplicationController
    before_filter :authenticate_spree_user!, except: [:authenticate]

    layout 'spree/layouts/spree_application'

    def authenticate
      if spree_user_signed_in?
        if current_spree_user.personalization_settings.present?
          redirect_to personalization_products_path
        else
          redirect_to edit_personalization_settings_path
        end
      else
        render :authenticate
      end
    end
  end
end
