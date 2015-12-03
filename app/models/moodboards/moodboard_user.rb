module Moodboards
  module MoodboardUser
    extend ActiveSupport::Concern

    included do
      has_many :moodboards,               class_name: "Moodboard",             inverse_of: :user
      has_many :moodboard_collaborations, class_name: 'MoodboardCollaborator', inverse_of: :user
      has_many :shared_moodboards,        class_name: "Moodboard", through: :moodboard_collaborations, source: :moodboard
    end

    def all_moodboards
      moodboards + shared_moodboards
    end
  end
end
