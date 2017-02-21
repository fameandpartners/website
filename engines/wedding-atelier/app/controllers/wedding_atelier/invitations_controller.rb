require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class InvitationsController < ApplicationController

    skip_before_filter :check_signup_completeness
    skip_before_filter :authenticate_spree_user!, only: :accept

    protect_from_forgery except: :create

    def create
      addresses = params[:email_addresses].reject(&:empty?)
      @event = WeddingAtelier::Event.find(params[:event_id])
      addresses.each do |email|
        invitation = @event.invitations.create(inviter_id: current_spree_user.id, user_email: email)
        invitation.send_invitation_email if invitation.valid?
      end
      current_spree_user.update_attribute(:wedding_atelier_signup_step, 'completed')
      respond_to do |format|
        format.html { redirect_to wedding_atelier.event_path(@event) }
        format.js { render json: @event.invitations.pending }
      end
    end

    def accept
      @invitation = Invitation.find(params[:invitation_id])
      if @invitation.state == 'accepted'
        flash[:notice] = 'This is invitation has already been accepted.'
        redirect_to wedding_atelier.signup_path
      else
        if spree_user_signed_in? && @invitation.accept
          redirect_to wedding_atelier.event_path(@invitation.event)
        elsif Spree::User.where("LOWER(email) = ?", @invitation.user_email.downcase).first
          @invitation.accept
          redirect_to wedding_atelier.sign_in_path({invitation_id: @invitation.id})
        else
          redirect_to wedding_atelier.signup_path({invitation_id: @invitation.id})
        end
      end
    end
  end
end
