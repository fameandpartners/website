module Concerns
  module Moodboards
    extend ActiveSupport::Concern

    included do
      helper_method :user_moodboards, :current_user_moodboard
    end

    def user_moodboards
      @user_moodboards ||= MoodboardsPresenter.new(current_spree_user)
    end

    # Legacy Moodboard Object
    def current_user_moodboard
      @user_moodboard ||= SingleLegacyMoodboardPresenter.new(current_spree_user)
    end
  end
end
