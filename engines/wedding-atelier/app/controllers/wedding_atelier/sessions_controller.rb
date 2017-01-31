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
      if params[:invitation_id]
        invitation = Invitation.find(params[:invitation_id])
        if invitation.user_email == params[:spree_user][:email]
          invitation.accept
        end
      end

      redirect_to wedding_atelier.events_path
    end
  end
end
