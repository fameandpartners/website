module Spree
  module WeddingAtelier
    class Invitation < ActiveRecord::Base
      after_create :send_invitation_email
      attr_accessible :event_slug, :user_email

      private

      def send_invitation_email
        InvitationsMailer.invite(event_slug, user_email).deliver! if user_email
      end
    end
  end
end
