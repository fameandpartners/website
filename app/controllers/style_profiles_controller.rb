class StyleProfilesController < ApplicationController
  include SslRequirement
  ssl_allowed
  protect_from_forgery

  #layout 'redesign/application'
  layout 'iframe'

  def show
    @style_profile = get_user_style_profile(current_spree_user)
    @recommended_products = get_recommended_dresses(@style_profile)
    @user_styles = get_user_styles(@style_profile)
  end

  private

    def get_recommended_dresses(profile)
      Spree::Product.recommended_for(profile, limit: 12)
    rescue Exception => e
      Spree::Product.last(12)
    end

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

    def get_user_styles(style_profile)
      styles = style_profile.percentage.map do |name, rate|
        OpenStruct.new(
          name: name.to_s,
          presentation: name.to_s,
          percentage: "#{ rate.to_i }%".html_safe,
          rate: rate.to_i
        )
      end
      styles.sort_by(&:rate).reverse
    end
end
