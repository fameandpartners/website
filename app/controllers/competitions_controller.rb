class CompetitionsController < ApplicationController
  before_filter :authenticate_spree_user!, except: [:show, :create]
  layout 'spree/layouts/spree_application'

  helper_method :final_competition_step_path

  # step 1 # GET
  def show
    session[:invite] = params[:invite] if params[:invite].present?

    @user = try_spree_current_user

    if @user.try(:competition_entry).present?
      session[:new_entrant] = nil
      redirect_to share_competition_path(@user.slug)
    end
  end

  # enter # POST
  def create
    if spree_user_signed_in?
      @user = try_spree_current_user
    elsif params[:email].present? and params[:password].present? # try login existing user
      @user = Spree::User.where(email: params[:email]).first_or_initialize 
      unless @user.valid_password?(params[:password])
        # invalid email or password
        @user.errors[:base] << t('devise.failure.invalid')
      end
    else
      @user = Spree::User.create_user(params.extract!(:email, :first_name, :last_name).merge(sign_up_reason: 'competition'))

      if @user.persisted?
        # Marketing pixel
        session[:signed_up_just_now] = true

        Spree::UserMailer.welcome_to_competition(@user).deliver
      end
    end

    if !@user.persisted? || @user.errors.present?
      render action: :show
    else
      sign_in(:spree_user, @user)
      entry = CompetitionEntry.create_for(@user, get_invitation)
      session[:new_entrant] = true

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
    redirect_to final_competition_step_path
  end

  # step 3 # GET
  def stylequiz
  end

  def final_competition_step_path
    url_params = {}
    url_params[:cf] = 'competition' if session[:new_entrant]

    if try_spree_current_user.try(:style_profile).present?
      my_boutique_url(url_params)
    else
      collection_path(url_params)
    end
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
