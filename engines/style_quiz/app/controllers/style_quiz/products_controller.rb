module StyleQuiz
  class ProductsController < ::StyleQuiz::ApplicationController

    # recommendations
    def show
      if style_profile.blank?
        redirect_to style_quiz.new_profile_path
      end

      service = StyleQuiz::ProductsRecommendations.new(style_profile: style_profile)
      products = service.read_all
    end

    def style_profile
    end
  end
end
