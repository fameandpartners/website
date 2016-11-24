module Spree
  module WeddingAtelier
    class RegistrationsController < Spree::UserRegistrationsController
      layout 'wedding_atelier'
      def new
        @user = Spree::User.new
        @signup_params = {
          site_version: current_site_version.code,
          portal: 'wedding-atelier'
         }
      end

      def create
        @user = build_resource(params[:spree_user])
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
          redirect_to size_wedding_atelier_signup_path
        else
          render :new
        end
      end

      def update
        @user = current_spree_user
        if @user.update_attributes(params[:spree_user])
          @user.add_role(@user.event_role, @user.events.last) if @user.event_role
          redirect_to action: @user.wedding_atelier_signup_step
        else
          render @user.wedding_atelier_signup_step
        end
      end

      def size
        @dress_sizes = Spree::OptionType.find_by_name('dress-size').option_values
        @heights = [
            "5'19 / 177cm ",
            "5'19 / 180cm ",
            "5'19 / 190cm ",
            "5'19 / 200cm "
        ]
      end

      def details
        @roles = ['bride', 'bridesmaid', 'maid of honor', 'mother of bride']
        @event = current_spree_user.events.new
      end

      def invite
        @event = current_spree_user.events.last
      end

      def send_invites
        event = current_spree_user.events.last
        addresses = params[:email_addresses].reject(&:empty?)
        InvitationsMailer.invite(event, addresses).deliver! if addresses.any?
        redirect_to new_wedding_atelier_signup_path(event_token: event.token)
      end

      private

      def set_user_role

      end

    end
  end
end
