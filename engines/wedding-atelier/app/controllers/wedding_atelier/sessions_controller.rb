module WeddingAtelier
  class SessionsController < Spree::UserSessionsController
    include WeddingAtelier::Concerns::FeatureFlaggable

    layout 'wedding_atelier/application'
    helper WeddingAtelier::Engine.helpers

    def new
      @user = Spree::User.new
      if params[:invitation_id]
        invitation = Invitation.find(params[:invitation_id])
        @signup_params = { invitation_id: params[:invitation_id] }
        @user.email = invitation.user_email if invitation
      end
      super
    end

    def create
      if params[:invitation_id]
        invitation = Invitation.find(params[:invitation_id])
        if invitation.user_email == params[:spree_user][:email]
          invitation.accept
        end
      end
      super
    end
  end
end
