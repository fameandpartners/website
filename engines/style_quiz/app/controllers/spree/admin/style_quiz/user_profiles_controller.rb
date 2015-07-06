module Spree::Admin::StyleQuiz
  class UserProfilesController < Spree::Admin::StyleQuiz::BaseController
    def index
      @user_profiles = model_class.order('updated_at desc').first(50)
    end

    private

      def model_class
        ::StyleQuiz::UserProfile
      end
  end
end
