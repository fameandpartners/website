module StyleQuiz
  class UserProfilesController < ::StyleQuiz::ApplicationController
    respond_to :html, :json

    def edit
      @title = "Style Quiz " + default_seo_title

      apply_stored_results

      @user_style_profile = user_style_profile

      @questions = StyleQuiz::Question.active.ordered.includes(:answers).to_a

      render layout: 'redesign/application'
    end

    def update
      if style_profile_answers_updater.apply(params[:answers])
        # create user
        create_user_automagically(user_style_profile) if current_spree_user.blank?

        # delete intermediate results
        reset_stored_results
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

      def style_profile_answers_updater
        @style_profile_answers_updater ||= begin 
            StyleQuiz::UserStyleProfiles::UserAnswers.new(
            site_version: current_site_version,
            style_profile: user_style_profile
          )
        end
      end

      def user_style_profile 
        @_user_style_profile ||= StyleQuiz::UserProfile.read(
          user: current_spree_user,
          token: session[:user_style_profile_token]
        )
      end

      def create_user_automagically(style_profile)
        service = StyleQuiz::AutomagicUserRegistrator.new(
          style_profile: style_profile
        )
        user = service.create
        if user
          sign_in(:spree_user, user)
        else
          session[:user_style_profile_token] = style_profile.token
        end
      rescue
        nil
      end

      def reset_stored_results
        cookies.delete('style_quiz:answers')
      end

      def apply_stored_results
        answers = HashWithIndifferentAccess.new(JSON.parse(raw_answers)) rescue {}
        style_profile_answers_updater.apply(answers)
      end
  end
end
