module Spree
  module WeddingAtelier
    class InvitationsController < Spree::WeddingAtelier::BaseController

      skip_before_filter :check_signup_completeness

      def create
        addresses = params[:email_addresses].reject(&:empty?)
        addresses.each do |email|
          Invitation.create(event_slug: params[:event_id], user_email: email)
        end
        current_spree_user.update_attribute(:wedding_atelier_signup_step, 'completed')
        redirect_to wedding_atelier_event_path(params[:event_id])
      end
    end
  end
end
