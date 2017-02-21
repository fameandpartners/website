module WeddingAtelier
  class EventAssistant < ActiveRecord::Base
    belongs_to :user, class_name: Spree.user_class.name
    belongs_to :event, class_name: 'WeddingAtelier::Event'

    after_destroy :destroy_invitation

    private

    def destroy_invitation
      invitation = event.invitations.where(user_email: user.email).first
      invitation.destroy if invitation
    end
  end
end
