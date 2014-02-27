class Competition::EntriesController < ApplicationController
  def new
    invite_token = store_invite_token

    @entrant = CompetitionEntrant.new(try_spree_current_user, invite_token, params)

    if @entrant.already_entered?
      #reset_new_entrant_flag
      redirect_to next_step_path(@entrant)
    else
      @user = @entrant.user
      render action: :new
    end
  end

  def create
    invite_token = load_invite_token

    @entrant = CompetitionEntrant.new(try_spree_current_user, invite_token, params)

    if @entrant.create
      sign_in(@entrant.user) unless spree_user_signed_in?
      redirect_to next_step_path(@entrant)
    elsif @entrant.email_already_taken?
      redirect_to next_step_path(@entrant)
    else
      @user = @entrant.user
      render action: :new
    end
  end

  private

#  def reset_new_entrant_flag
#    session[:new_entrant] = nil
#  end

  def store_invite_token
    session[:invite] = params[:invite] if params[:invite].present?
  end

  def load_invite_token
    params[:invite].present? ? params[:invite] : session[:invite]
  end

  def next_step_path(entrant)
    case entrant.next_step.to_sym
    when :restore_password
      new_spree_user_password_path(entrant.url_options)
    when :new_entry
      competition_entry_path
    when :competition_boutique
      my_boutique_path(user: entrant.user.slug)
    when :competition_quiz
      root_path(entrant.url_options)
    else
      competition_entry_path
    end
  end

  class CompetitionEntrant
    attr_accessor :user

    def initialize(user, token, params)
      @user = user
      @params = params
      @token = token
    end

    def already_entered?
      @user.present? && competition_entry.present?
    end

    def create
      return true if already_entered?

      if @user.blank?
        @user = create_user
      end

      if @user.persisted?
        create_new_entrant(@user)
      end
    end

    def next_step
      if email_already_taken?
        :restore_password
      elsif !already_entered?
        :new_entry
      elsif competition_boutique_available?
        :competition_boutique
      else
        :competition_quiz
      end
    end

    def competition_name
      @params[:competition_id] || Competition.current
    end

    def competition_slug
      @params[:competition_id].gsub(/\W/, '') || Competition.slug
    end

    def email_already_taken? 
      @user.present? && @user.errors.added?(:email, :taken)
    end

    def url_options
      { cf: "competition-#{ competition_slug }" }
    end

    private

    def create_user
      # TODO: move user creation process to service..
      user = Spree::User.create_user(
        @params.extract!(:email, :first_name, :last_name).merge(
          sign_up_reason: "competition"
        )
      )
      if user.persisted?
        session[:signed_up_just_now] = true
      else
        user.errors.delete(:sign_up_reason) if user.errors
      end

      user
    end

    def create_new_entrant(user)
      return false if !user.persisted?

      Competition::Entry.create_for(user, competition_name, competition_invite)
      #Spree::UserMailer.welcome_to_competition(user).deliver
    end

    def competition_entry
      @competition_entry ||= @user.competition_entries.where(master: true).for_competition(competition_name).first
    end

    def competition_invite
      @competition_invite ||= begin
        if @token.present? 
          Competition::Invite.where(token: @token, competition_name: competition_name).first
        else
          nil
        end
      end
    end

    def competition_boutique_available?
      @user.present? && @user.style_profile.present?
    end
  end
end
=begin
class Competition::EntriesController < ApplicationController
  def new
    # store invite parameters to session
    # check user can enter to this competition
    #   - show if can
    #   - else if already entered redirect to /?cf=competition-greggsulkin
    #   - else if already entered & completed quiz to my-botique
  end

  def create
    # trying to make new entrant
      # if user logged in & not entrant
      # if user not logged in:
        # facebook log in check
        # if user created 
          # entrant
        # else
         # show errors
        # if email already has been taken  - redirect to 
          # /restore_password/?cf=competition-greggsulkin
  end
end
=end
