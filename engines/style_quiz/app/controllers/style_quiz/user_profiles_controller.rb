module StyleQuiz
  class UserProfilesController < ::StyleQuiz::ApplicationController
    respond_to :html, :json

    def edit
      @user_style_profile = user_style_profile
      @questions = StyleQuiz::Question.active.ordered.includes(:answers).to_a

      render layout: 'redesign/application'
    end

    def update
      answer_values = {
        fullname: params[:answers][:fullname],
        email:    params[:answers][:email],
        birthday: Date.strptime(params[:answers][:birthday], I18n.t('date_format.backend'))
      }
      user_style_profile.update_answers(
        answer_ids:     params[:answers][:ids],
        events:         (params[:answers][:events] || {}).values,
        answer_values:  answer_values
      )

      if current_spree_user.blank?
        unless create_user_automagically(user_style_profile)
          session[:user_style_profile_token] = user_style_profile.token
        end
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
        @user_style_profile ||= StyleQuiz::UserProfile.read(
          user: current_spree_user,
          token: session[:user_style_profile_token]
        )
      end

      def create_user_automagically(style_profile)
        first_name, last_name = style_profile.fullname.split(' ', 2)
        user = Spree::User.new(
          first_name: first_name,
          last_name: last_name,
          email: style_profile.email,
          skip_welcome_email: true,
          automagically_registered: true
        )
        user.birthday = style_profile.birthday

        if user.save
          sign_in :spree_user, user
          user_style_profile.assign_to_user(user)
          return true
        else
          return false
        end

      rescue
        return false
      end
  end
end
