module StyleQuiz
  class ProductsController < ::StyleQuiz::ApplicationController

    # recommendations
    def show
      if style_profile.blank?
        redirect_to style_quiz.new_profile_path
      end

      service = StyleQuiz::ProductsRecommendations.new(style_profile: style_profile)
      @products = service.read_all
    end

    private

    def style_profile
      if session[:user_style_profile_token]
        profile = StyleQuiz::UserProfile.find_by_token(session[:user_style_profile_token])
        return profile if profile.present?
      end
      if current_spree_user.present?
        return current_spree_user.style_profiles.last
      end
    end
  end
end
