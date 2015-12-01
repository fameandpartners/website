class MoodboardCollaborator < ActiveRecord::Base
  belongs_to :moodboard, inverse_of: :collaborators
  belongs_to :user,  class_name: 'Spree::User', inverse_of: :moodboard_collaborations

  validates_presence_of :name
  validates_presence_of :email

  validates_uniqueness_of :email, scope: :moodboard_id

  attr_accessible :deleted_at, :deleted_by, :email, :mute_notifications, :name

  def set_user
    if candidate_user = Spree::User.find_by_email(email)
      self.user = candidate_user
    end
  end

  def as_json(*options)
    {
      name:       name,
      email:      email,
      created_at: created_at,
      raw: super
    }
  end
end
