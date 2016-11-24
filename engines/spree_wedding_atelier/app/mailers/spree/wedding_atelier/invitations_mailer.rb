module Spree
  module WeddingAtelier
    class InvitationsMailer < ActionMailer::Base

      def invite(event, addresses)
        @event = event
        mail(to: addresses,
             from: 'contact@fameandpartners.com',
             subject: "You've been invited to janines wedding")
      end
    end
  end
end
