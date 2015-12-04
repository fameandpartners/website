class MoodboardCollaborator < ActiveRecord::Base
  belongs_to :moodboard, inverse_of: :collaborators
  belongs_to :user,  class_name: 'Spree::User', inverse_of: :moodboard_collaborations

  before_create :set_user_from_email
  after_create :track_as_invited

  validates_presence_of :name
  validates_presence_of :email

  validates_uniqueness_of :email, scope: :moodboard_id

  attr_accessible :deleted_at, :deleted_by, :email, :mute_notifications, :name

  scope :active,       -> { where(deleted_at: nil) }
  scope :unassociated, -> { where(user_id: nil) }
  scope :for_email,    -> (email) { where(email: email) }

  def set_user_from_email
    return if self.user.present?

    if candidate_user = Spree::User.find_by_email(email)
      self.user = candidate_user
    end
    true
  end

  def track_as_invited
    trackable = {id: email, email: email}

    mb = MoodboardsPresenter::MoodboardPresenter.new(moodboard)
    extra_data = {
      moodboard_path:        mb.show_path,
      moodboard_url:         mb.show_url,
      moodboard_name:        mb.name,
      invitee_name:          self.name,
      invited_by_name:       mb.owner_name,
      invited_by_first_name: mb.owner_first_name,
      invited_by_email:      mb.owner_email
    }

    tracker = Marketing::CustomerIOEventTracker.new
    tracker.client.identify(trackable)


    tracker.track(email, 'invited_to_moodboard', extra_data)
  end

  def as_json(*options)
    {
      name:       name,
      email:      email,
      created_at: created_at,
    }
  end
end
