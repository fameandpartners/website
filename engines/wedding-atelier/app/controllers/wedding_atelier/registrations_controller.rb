module WeddingAtelier
  class RegistrationsController < Spree::UserRegistrationsController
    include WeddingAtelier::Concerns::FeatureFlaggable

    layout 'wedding_atelier/application'
    before_filter :check_spree_user_signed_in, except: [:new, :create]
    before_filter :redirect_if_completed, except: :new
    before_filter :sign_in_if_exists, only: :create
    helper WeddingAtelier::Engine.helpers

    def new
      if current_spree_user
        if current_spree_user.wedding_atelier_signup_complete?
          redirect_to wedding_atelier.events_path
        else
          redirect_to action: current_spree_user.wedding_atelier_signup_step
        end
      end
      if params[:invitation_id]
        invitation = Invitation.find(params[:invitation_id])
        @signup_params = { invitation_id: invitation.id }
      end

      @user = Spree::User.new(email: invitation.try(:user_email))
      @user.build_user_profile(skip_validation: true)
    end

    def create
      @user = build_resource(spree_user_params)
      if resource.new_record?
        resource.sign_up_via    = Spree::User::SIGN_UP_VIA.index('Email')
        resource.sign_up_reason = session[:sign_up_reason]
      end
      if resource.save
        EmailCaptureWorker.perform_async(resource.id, remote_ip:    request.remote_ip,
                                                      landing_page: session[:landing_page],
                                                      utm_params:   session[:utm_params],
                                                      site_version: current_site_version.name,
                                                      form_name:    'Register')

        session.delete(:sign_up_reason)
        sign_in :spree_user, resource
        set_flash_message(:notice, :signed_up)
        session[:spree_user_signup] = true
        associate_user
        # Marketing pixel
        flash[:signed_up_just_now] = true
        if params[:invitation_id]
          invitation = Invitation.find(params[:invitation_id]).accept
          session[:accepted_invitation] = true
        end
        redirect_to wedding_atelier.size_signup_path
      else
        render :new
      end
    end

    def update
      prepare_form_default_values
      if @user.update_attributes(spree_user_params)
        @user.add_role(@user.event_role, @user.events.last) if @user.event_role
        if @user.wedding_atelier_signup_step == 'completed'
          redirect_to wedding_atelier.event_path(@user.events.last)
        else
          redirect_to action: @user.wedding_atelier_signup_step
        end
      else
        @event = @user.events.last
        render @user.wedding_atelier_signup_step_was
      end

      if @user.reload.wedding_atelier_signup_complete?
        Marketing::CustomerIOEventTracker.new.track(@user, 'wedding_atelier_welcome', user_name: @user.first_name)
      end

    end

    def size
      prepare_form_default_values
    end

    def details
      prepare_form_default_values
      @event = current_spree_user.events.last || current_spree_user.events.new
    end

    def invite
      @event = current_spree_user.events.last
      if @event.number_of_assistants == 0
        current_spree_user.update_attribute(:wedding_atelier_signup_step, 'completed')
        redirect_to wedding_atelier.event_path(id: @event.id, slug: @event.slug)
      end
    end


    private

    def sign_in_if_exists
      user = Spree::User.where(email: spree_user_params[:email]).first
      if user
        allow_params_authentication!
        authenticate_spree_user!
        if spree_user_signed_in? && user.wedding_atelier_signup_complete?
          event = user.events.last
          redirect_to wedding_atelier.event_path(id: event.id, slug: event.slug)
        elsif spree_user_signed_in?
          redirect_to action: user.wedding_atelier_signup_step
        else
          redirect_to sign_in_path, flash: { error:  t('devise.failure.invalid') }
        end
      end
    end

    def prepare_form_default_values
      @user = current_spree_user
      @user.build_user_profile unless @user.user_profile

      @roles = {
        'Bride' => 'bride',
        'Bridesmaid' => 'bridesmaid',
        'Maid of honor' => 'maid of honor',
        'Mother of bride' => 'mother of bride'
      }
      # if current_spree_user.wedding_atelier_signup_step != 'size'
      #   @event = current_spree_user.events.last || current_spree_user.events.new
      # end

      @next_signup_step_value = session[:accepted_invitation] ? 'completed' : 'details'

      @heights = WeddingAtelier::Height.definitions

      @site_version = env['site_version_code'] || 'us'
      @dress_sizes = Spree::OptionType.size.option_values
    end

    def spree_user_params
      # email input is disabled in new form, to guarantee
      # invited user uses that email.
      # Since disabled inputs are not sent, here we set
      # the user email in the params from the invitation.
      if !params[:spree_user][:email] && params[:invitation_id]
        invitation = Invitation.find(params[:invitation_id])
        params[:spree_user][:email] = invitation.user_email
      end
      params[:spree_user]
    end

    def check_spree_user_signed_in
      redirect_to(wedding_atelier.signup_path) unless spree_user_signed_in?
    end

    def redirect_if_completed
      redirect_to(wedding_atelier.events_path) if current_spree_user.try(:wedding_atelier_signup_complete?) && action_name != 'invite'
    end
  end
end
