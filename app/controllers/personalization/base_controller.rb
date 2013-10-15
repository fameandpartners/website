module Personalization
  class BaseController < ApplicationController
    before_filter :authenticate_spree_user!

    layout 'spree/layouts/spree_application'

    def authenticate_spree_user!
      redirect_to personalization_path unless spree_user_signed_in?
    end
  end
end
