module WeddingAtelier
  class Invitation < ActiveRecord::Base
    attr_accessible :user_email, :event_id, :inviter_id

    validates :user_email, presence: true, uniqueness: { scope: :event_id, allow_blank: false }
    belongs_to :inviter, class_name: 'Spree::User'
    belongs_to :event

    scope :pending, -> { where(state: 'pending') }

    def accept
      user = Spree::User.where("LOWER(email) = ?", user_email.downcase).first
      if user
        event.assistants << user
        update_attribute(:state, 'accepted')
        user.add_role 'bridesmaid', event
        event.save!
      end
    end

    def send_invitation_email
      routes = WeddingAtelier::Engine.routes.url_helpers
      invitation_attrs = {
        recipient: user_email,
        invited_by_email: inviter.email,
        invited_by_first_name: inviter.first_name,
        invited_by_name: inviter.full_name,
        invitee_name: user_email,
        moodboard_name: event.name,
        moodboard_path: routes.event_invitation_accept_path(event_id: self.event_id, invitation_id: self.id),
        moodboard_url: routes.event_invitation_accept_url(event_id: self.event_id, invitation_id: self.id, host: 'fameandpartners.com', protocol: 'https')
      }
      Marketing::CustomerIOEventTracker.new.anonymous_track('invited_to_moodboard', invitation_attrs)
    end
  end
end
