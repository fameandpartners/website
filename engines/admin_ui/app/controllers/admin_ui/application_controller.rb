module AdminUi
  class ApplicationController < ActionController::Base

    # Using Spree for user authentication right now.
    include Spree::Core::ControllerHelpers::Auth
    include Spree::Core::ControllerHelpers::RespondWith
    include Spree::Core::ControllerHelpers::Common

    before_filter :authorize_admin

    layout 'admin_ui'

    helper_method :current_admin_user, :page_title

    def page_title
      @page_title ||= controller_name.titleize
    end

    # Prefer this method to exposing Spree to the rest of the admin app
    def current_admin_user
      current_spree_user
    end

    private

    def authorize_admin
      # Hacky Hacketry Hacks
      (current_spree_user && current_spree_user.has_spree_role?('admin')) or fail CanCan::AccessDenied
    end

    # Cribbed from somewhere unspeakable deep inside Spree.
    def unauthorized
      if current_spree_user
        flash[:error] = t(:authorization_failure)
        redirect_to '/unauthorized'
      else
        # store_location
        # url = respond_to?(:spree_login_path) ? spree_login_path : root_path

        # redirect_to main_app.login_path
        redirect_to '/login'
      end
    end
  end
end
