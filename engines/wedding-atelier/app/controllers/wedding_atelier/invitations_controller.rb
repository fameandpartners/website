require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class InvitationsController < ApplicationController

    skip_before_filter :check_signup_completeness
    skip_before_filter :authenticate_spree_user!, only: :accept

    def create
      addresses = params[:email_addresses].reject(&:empty?)
      addresses.each do |email|
        Invitation.create(event_slug: params[:event_id], user_email: email)
      end
      current_spree_user.update_attribute(:wedding_atelier_signup_step, 'completed')
      redirect_to wedding_atelier.event_path(params[:event_id])
    end

    def accept
      @invitation = Invitation.find(params[:invitation_id])
      check_invitation_state(@invitation)
      if spree_user_signed_in? && @invitation.accept
        redirect_to wedding_atelier.event_path(@invitation.event_slug)
      elsif Spree::User.find_by_email(@invitation.user_email)
        @invitation.accept
        redirect_to wedding_atelier.sign_in_path({invitation_id: @invitation.id})
      else
        redirect_to wedding_atelier.signup_path({invitation_id: @invitation.id})
      end
    end

    private

    def check_invitation_state(invitation)
      if invitation.state == 'accepted'
        flash[:notice] = 'This is invitation has already been accepted.'
        redirect_to wedding_atelier.signup_path
      end
    end
  end
end
