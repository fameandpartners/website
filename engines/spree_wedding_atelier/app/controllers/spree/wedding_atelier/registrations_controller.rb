module Spree
  module WeddingAtelier
    class RegistrationsController < Spree::UserRegistrationsController
      layout 'wedding_atelier'
      def new
        @spree_user = Spree::User.new
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
          @user.create_wedding

          # Marketing pixel
          flash[:signed_up_just_now] = true
          redirect_to size_wedding_atelier_signup_path
        else
          render :new
        end
      end

      def update
        if current_spree_user.update_attributes(params[:spree_user])
          redirect_to action: current_spree_user.wedding_atelier_signup_step
        else
          render current_spree_user.wedding_atelier_signup_step
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
        @roles = Spree::Role.where(name: ['bride', 'bridesmaid'])
      end

      def invite
      end

    end
  end
end
