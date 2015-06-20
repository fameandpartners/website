module StyleQuiz
  class UserProfilesController < ::StyleQuiz::ApplicationController
    respond_to :html, :json

    def edit
      @user_style_profile = user_style_profile
      @questions = StyleQuiz::Question.active.ordered.includes(:answers).to_a
    end

    def update
      user_style_profile.update_answers(
        answers_ids:  params[:answers][:ids],
        events:       (params[:answers][:events] || {}).values,
        answers_values: params[:answers].except(:ids, :events)
      )
      if current_spree_user.blank?
        session[:user_style_profile_token] = user_style_profile.token
      end

      respond_to do |format|
        format.html { redirect_to main_app.user_style_profile_path }
        format.json { render json: { redirect_to: main_app.user_style_profile_path }}
      end
    end

    def show
      @user_style_profile = user_style_profile

      @products = StyleQuiz::ProductsRecommendations.new(
        style_profile: @user_style_profile
      ).read_all
    end

    private

      def user_style_profile 
        StyleQuiz::UserProfile.read(
          user: current_spree_user,
          token: session[:user_style_profile_token]
        )
      end
  end
end
