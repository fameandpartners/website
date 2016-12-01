module WeddingAtelier
  class InvitationsMailer < ActionMailer::Base

    def invite(invitation)
      @invitation = invitation
      @event = Event.find_by_slug(@invitation.event_slug)
      mail(to: @invitation.user_email,
           from: 'contact@fameandpartners.com',
           subject: "You've been invited to #{@event.name}")
    end
  end
end
