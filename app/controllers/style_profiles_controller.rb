class StyleProfilesController < ApplicationController
  include SslRequirement
  ssl_allowed
  protect_from_forgery

  #layout 'redesign/application'
  layout 'iframe'

  def show
    @style_profile = get_user_style_profile(current_spree_user)
    @recommended_products = Spree::Product.recommended_for(@style_profile, limit: 20)
  end

  private

    def get_user_style_profile(user)
      # trying to associate user
      if session[:style_profile_id]
        profile = UserStyleProfile.where(id: session[:style_profile_id]).first
        if profile.token == session[:style_profile_access_token]
          if user.present? && profile.user_id.blank?
            profile.update_column(:user_id, user.id)
            session[:style_profile_id] = nil
            session[:style_profile_access_token] = nil
          end
          return profile
        end
      end

      if user.present? && user.style_profile.present? 
        return user.style_profile
      else
        raise CanCan::AccessDenied
      end
    end
end
