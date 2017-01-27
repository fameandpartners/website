require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class InvitationsController < ApplicationController

    skip_before_filter :check_signup_completeness
    skip_before_filter :authenticate_spree_user!, only: :accept

    protect_from_forgery except: :create

    def create
      addresses = params[:email_addresses].reject(&:empty?)
      @event = WeddingAtelier::Event.where(slug: params[:event_id]).first
      addresses.each do |email|
        @event.invitations.create(inviter: current_spree_user, user_email: email)
      end
      current_spree_user.update_attribute(:wedding_atelier_signup_step, 'completed')
      respond_to do |format|
        format.html { redirect_to wedding_atelier.event_path(params[:event_id]) }
        format.js { render json: { status: :ok, invitations: @event.invitations } }
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
        elsif Spree::User.find_by_email(@invitation.user_email)
          @invitation.accept
          redirect_to wedding_atelier.sign_in_path({invitation_id: @invitation.id})
        else
          redirect_to wedding_atelier.signup_path({invitation_id: @invitation.id})
        end
      end
    end
  end
end
