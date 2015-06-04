module StyleQuiz
  class ProfilesController < ::StyleQuiz::ApplicationController
    def new
      @questions = StyleQuiz::UserQuestions.new(
        user: current_spree_user
      ).read_all
    end

    # Parameters: {
    #   "answers"=>{
    #     "fullname"=>"Evgeniy Petrov", 
    #     "birthdate"=>"malleus.petrov@gmail.com", 
    #     "email"=>"1995-06-04", 
    #     "ids"=>["5", "18", "38", "28", "42", "44", "45", "51", "82", "120", "121", "122", "160", "161", "164", "175"]}}
    def create
      profile = StyleQuiz::StyleProfile.new(
        user: current_spree_user,
        answers_ids: params[:answers][:ids],
        answers_values: params[:answers].except(:ids)
      ).create

      binding.pry

      store_profile(current_spree_user, profile)

      redirect_to product_result
    # rescue StyleQuiz::Errors::SomethingWrong
    end

    private

      def store_profile(user, profile)
        if session[:user_style_profile_token]
          StyleQuiz::StyleProfile.where(token: session[:user_style_profile_token]).destroy_all
        end

        if user
          user.style_profiles.destroy_all
          user.style_profiles << profile
        else
          profile.generate_token
          session[:user_style_profile_token] = profile.token
        end

      #rescue
      end
  end
end
