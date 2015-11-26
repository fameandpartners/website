class MoodboardCollaborator < ActiveRecord::Base
  belongs_to :moodboard, inverse_of: :collaborators
  belongs_to :user,  class_name: 'Spree::User', inverse_of: :moodboard_collaborations
  attr_accessible :deleted_at, :deleted_by, :email, :mute_notifications, :name
end
