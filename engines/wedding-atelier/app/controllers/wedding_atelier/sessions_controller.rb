module WeddingAtelier
  class SessionsController < Spree::UserSessionsController
    include WeddingAtelier::Concerns::FeatureFlaggable

    layout 'wedding_atelier/application'
    helper WeddingAtelier::Engine.helpers

    skip_before_filter :require_no_authentication

    def new
      @user = Spree::User.new

      if params[:invitation_id]
        invitation = Invitation.find(params[:invitation_id])
        @signup_params = { invitation_id: params[:invitation_id] }
        @user.email = invitation.user_email if invitation
      end
      if current_spree_user
        redirect_to wedding_atelier.events_path
      end
    end

    def create
      authenticate_spree_user!
      if spree_user_signed_in?
        user_email = params.dig(:spree_user, :email)
        invitation = Invitation.where(id: params[:invitation_id], user_email: user_email).first
        invitation.accept if invitation
        redirect_to wedding_atelier.events_path
      else
        flash.now[:error] = t('devise.failure.invalid')
        render :new
      end
    end
  end
end
