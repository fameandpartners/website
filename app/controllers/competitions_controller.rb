class CompetitionsController < ApplicationController
  before_filter :authenticate_spree_user!, except: [:show, :enter]
  layout 'spree/layouts/spree_application'

  # step 1 # GET
  def show
    session[:invite] = params[:invite] if params[:invite].present?
    @user = try_spree_current_user
  end

  def enter
    if @user = try_spree_current_user
      @user.update_attributes(params.extract!(:first_name, :last_name))
    elsif params[:email].present? and params[:password].present? # try login existing user
      user = Spree::User.where(email: params[:email]).first
      @user = user if user.valid_password?(params[:password])
    else
      @user = Spree::User.create_user(params.extract!(:email, :first_name, :last_name))
    end

    if !@user.persisted?
      flash.now[:notice] = "can't create"
      render action: :show
    else
      sign_in(:spree_user, @user)
      entry = CompetitionEntry.create_for(@user, get_invitation)

      redirect_to share_competition_path(@user.slug)
    end
  end

  # step 2 # GET
  def share
    @user = try_spree_current_user
    ensure_user_joined_to_competition(@user)

    @invitation = CompetitionInvitation.fb_invitation_from(@user)
  end

  # send invitaitons & redirect to last step
  def invite
    create_invitations(params[:name], params[:email])
    redirect_to stylequiz_competition_path
  end

  # step 3 # GET
  def stylequiz
  end

  private

  # logged through fb user comes here with GET request
  def ensure_user_joined_to_competition(user)
    CompetitionEntry.create_for(user, get_invitation)
  end

  def create_invitations(names, emails)
    user = try_spree_current_user
    names ||= {}
    emails ||= {}
    names.each do |key, name|
      email = emails[key]
      CompetitionInvitation.send_from(user, name, email)
    end
  end

  def get_invitation
    invitation = nil
    invitation = CompetitionInvitation.where(token: params[:invite]).first if params[:invite].present?
    invitation ||= CompetitionInvitation.where(token: session[:invite]).first if session[:invite].present?
  end
end
