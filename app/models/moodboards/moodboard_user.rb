module Moodboards
  module MoodboardUser
    extend ActiveSupport::Concern

    included do
      has_many :moodboards,               class_name: "Moodboard",             inverse_of: :user
      has_many :moodboard_collaborations, class_name: 'MoodboardCollaborator', inverse_of: :user
      has_many :shared_moodboards,        class_name: "Moodboard", through: :moodboard_collaborations, source: :moodboard

      after_create :accept_moodboard_invitations
    end

    def all_moodboards
      moodboards + shared_moodboards
    end

    def accept_moodboard_invitations
      MoodboardCollaborator.active.unassociated.for_email(self.email).map do |pending_collaboration|
        pending_collaboration.accepted_at = DateTime.current
        pending_collaboration.user = self
        pending_collaboration.save
      end
      true
    end
  end
end
