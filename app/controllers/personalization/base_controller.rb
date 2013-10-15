module Personalization
  class BaseController < ApplicationController
    before_filter :authenticate_spree_user!, except: [:authenticate, :show, :index]

    layout 'spree/layouts/spree_application'

    def authenticate
      if spree_user_signed_in?
        redirect_to personalization_products_path
      else
        render :authenticate
      end
    end
  end
end
