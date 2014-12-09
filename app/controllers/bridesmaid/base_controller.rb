class Bridesmaid::BaseController < ApplicationController
  # defines custom errors
  module Bridesmaid::Errors; end
  class Bridesmaid::Errors::SpreeUserNotLoggedIn < StandardError; end
  class Bridesmaid::Errors::SpreeUserLoggedIn < StandardError; end
  class Bridesmaid::Errors::NotDevelopedYet < StandardError; end
  class Bridesmaid::Errors::ConsiergeServiceNotFound < StandardError; end
  class Bridesmaid::Errors::ConsiergeServiceStepDisabled < StandardError; end
  class Bridesmaid::Errors::ProfileNotCompleted < StandardError; end
  class Bridesmaid::Errors::MoodboardOwnerNotFound < StandardError; end
  class Bridesmaid::Errors::MoodboardAccessDenied < StandardError; end
  class Bridesmaid::Errors::MoodboardNotReady < StandardError; end
  class Bridesmaid::Errors::MoodboardNotAvailable < StandardError; end

  rescue_from Bridesmaid::Errors::SpreeUserNotLoggedIn, with: :redirect_to_landing_page
  rescue_from Bridesmaid::Errors::SpreeUserLoggedIn, with: :redirect_to_details_page
  rescue_from Bridesmaid::Errors::NotDevelopedYet, with: :redirect_to_main_app
  rescue_from Bridesmaid::Errors::ConsiergeServiceNotFound, with: :redirect_to_dresses_page
  rescue_from Bridesmaid::Errors::ConsiergeServiceStepDisabled, with: :redirect_to_dresses_page
  rescue_from Bridesmaid::Errors::ProfileNotCompleted, with: :redirect_to_color_selection_page
  rescue_from Bridesmaid::Errors::MoodboardOwnerNotFound, with: :redirect_to_main_app
  rescue_from Bridesmaid::Errors::MoodboardAccessDenied, with: :redirect_to_landing_page
  rescue_from Bridesmaid::Errors::MoodboardNotReady, with: :redirect_to_landing_page
  rescue_from Bridesmaid::Errors::MoodboardNotAvailable, with: :redirect_to_bride_moodboard

  #before_filter :hide_module

  protected

    #def current_spree_user
    #  @current_spree_user ||= Spree::User.find(19441)
    #end

    def show_bridesmaid_header
      moodboard_owner # ensure user loaded
      @bridesmaid_viewing = true
    end

    def hide_module
      if Rails.env.production?
        raise Bridesmaid::Errors::NotDevelopedYet
      end
    end

    def require_user_logged_in!
      raise Bridesmaid::Errors::SpreeUserNotLoggedIn if current_spree_user.blank?
    end

    def require_user_not_logged_in!
      raise Bridesmaid::Errors::SpreeUserLoggedIn if current_spree_user.present?
    end

    def require_completed_profile!
      raise Bridesmaid::Errors::ProfileNotCompleted if !bridesmaid_user_profile.completed?
    end

    def load_moodboard_owner!
      raise Bridesmaid::Errors::MoodboardOwnerNotFound if moodboard_owner.blank?
    end

    def redirect_to_landing_page(exception)
      redirect_to(bridesmaid_party_path)
    end

    def redirect_to_details_page(exception)
      redirect_to(bridesmaid_party_info_path)
    end

    def redirect_to_main_app(exception)
      redirect_to root_path
    end

    def redirect_to_dresses_page(exception)
      redirect_to bridesmaid_party_dresses_path
    end

    def redirect_to_color_selection_page(exception)
      redirect_to bridesmaid_party_colour_path
    end

    def redirect_to_bride_moodboard(exception)
      redirect_to wishlist_path
    end
    # eo of code, related to exceptions handling

  private

    def bridesmaid_user_profile
      @bridesmaid_user_profile ||= begin
        require_user_logged_in!

        BridesmaidParty::Event.where(
          spree_user_id: current_spree_user.id
        ).first_or_initialize
      end
    end

    def bridesmaid_event_profile
      bridesmaid_user_profile
    end

    # note - this is bride, and general setting for microsite, rename?
    def moodboard_owner
      @moodboard_owner ||= begin
        owner = nil
        if params[:user_slug].present?
          owner = Spree::User.where(slug: params[:user_slug]).first
        end
        owner ||= current_spree_user
        @bride = owner
        owner
      end
    end

    def set_page_titles(options = {})
      @title        = options[:title].present?       ? options[:title] : 'Bridesmaid Party'
      @description  = options[:description].present? ? options[:description] : 'Bridesmaid Party'
    end
end
