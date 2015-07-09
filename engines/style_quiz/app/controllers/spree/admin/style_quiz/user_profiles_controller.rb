module Spree::Admin::StyleQuiz
  class UserProfilesController < Spree::Admin::StyleQuiz::BaseController
    def index
      @search = model_class.ransack(params[:q])
      @user_profiles = @search.result(distinct: true).limit(10)
    end

    def show
      @user_profile = model_class.find(params[:id])
    end

    private

      def model_class
        ::StyleQuiz::UserProfile
      end
  end
end
