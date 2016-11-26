module Spree
  module WeddingAtelier
    class InvitationsMailer < ActionMailer::Base

      def invite(event_slug, user_email)
        @event = Event.find_by_slug(event_slug)
        mail(to: user_email,
             from: 'contact@fameandpartners.com',
             subject: "You've been invited to #{@event.name}")
      end
    end
  end
end
