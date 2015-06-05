#class StyleQuiz::ProductsController < ::StyleQuiz::ApplicationController
class StyleQuiz::ProductsController < ApplicationController
  layout 'redesign/application'

  # recommendations
  def show
    if style_profile.blank?
      redirect_to(style_quiz.new_profile_path) and return
    end

    service = StyleQuiz::ProductsRecommendations.new(style_profile: style_profile)
    @products = service.read_all
  end

  private

  def style_profile
    @style_profile ||= StyleQuiz::UserStyleProfileLoader.new(
      user: current_spree_user,
      token: session[:user_style_profile_token]
    ).load
  end
  helper_method :style_profile
end
