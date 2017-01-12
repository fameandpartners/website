module WeddingAtelier
  class Invitation < ActiveRecord::Base
    after_create :send_invitation_email
    attr_accessible :event_slug, :user_email

    scope :pending, -> { where(state: 'pending') }

    validates :user_email, presence: true, uniqueness: { scope: :event_slug, allow_blank: false }

    def accept
      user = Spree::User.find_by_email(user_email)
      event = Event.find_by_slug(event_slug)
      if user && event
        event.assistants << user
        update_attribute(:state, 'accepted')
        event.save!
      end
    end

    private

    def send_invitation_email
      InvitationsMailer.invite(self).deliver!
    end
  end
end
