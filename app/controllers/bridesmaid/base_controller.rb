class Bridesmaid::BaseController < ApplicationController
  # difines custom errors
  module Bridesmaid::Errors; end
  class Bridesmaid::Errors::SpreeUserNotLoggedIn < StandardError; end
  class Bridesmaid::Errors::SpreeUserLoggedIn < StandardError; end
  class Bridesmaid::Errors::NotDevelopedYet < StandardError; end

  rescue_from Bridesmaid::Errors::SpreeUserNotLoggedIn, with: :redirect_to_landing_page
  rescue_from Bridesmaid::Errors::SpreeUserLoggedIn, with: :redirect_to_details_page
  rescue_from Bridesmaid::Errors::NotDevelopedYet, with: :redirect_to_main_app

  before_filter :hide_module

  protected

    def hide_module
      if !Rails.env.development?
        raise Bridesmaid::Errors::NotDevelopedYet
      end
    end

    def require_user_logged_in!
      raise Bridesmaid::Errors::SpreeUserNotLoggedIn if current_spree_user.blank?
    end

    def require_user_not_logged_in!
      raise Bridesmaid::Errors::SpreeUserLoggedIn if current_spree_user.present?
    end

    def redirect_to_landing_page(exception)
      redirect_to(bridesmaid_party_path)
    end

    def redirect_to_details_page(exception)
      redirect_to(bridesmaid_party_info_path)
    end

    def redirect_to_main_app(exception)
      redirect_to '/'
    end


    def bridesmaid_user_profile
      @bridesmaid_user_profile ||= begin
        require_user_logged_in!

        BridesmaidUserProfile.where(
          spree_user_id: current_spree_user.id
        ).first_or_initialize
      end
    end

    def set_page_titles(title = nil, description = nil)
      @title        = title.present?       ? title : 'Bridesmaid Party'
      @description  = description.present? ? description : 'Bridesmaid Party'
    end
end
