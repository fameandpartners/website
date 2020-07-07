module Api
  module V1
    class UserSessionsController < ApplicationController #< Devise::SessionsController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth
      # include Spree::Core::ControllerHelpers::Common
      # include Spree::Core::ControllerHelpers::Order

      ssl_required :new, :create, :destroy, :signup, :reset_password, :send_reset_password_email

      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        ensure_params_exist

        @user = Spree::User.find_for_authentication(:email => params[:spree_user][:email])
        puts("hhhhhhhhhhhhhhhh")
        puts(@user.encrypted_password)
        return invalid_login_attempt unless @user

        if @user.valid_password?(params[:spree_user][:password])
          sign_in("spree_user", @user)

          if params[:spree_user][:remember_me].present? and params[:spree_user][:remember_me]
            @user.remember_me!
          end

          respond_with @user
          return
        end

        invalid_login_attempt
      end

      def signup
        @user = Spree::User.find_for_authentication(:email => params[:spree_user][:email]) || Spree::User.new(params[:spree_user])

        if !@user.new_record? or !@user.save
          render :json=>{:success=>false, :message=>"User already exists"}, :status=>401
          return
        end

        @user.sign_up_via    = Spree::User::SIGN_UP_VIA.index('Email')
        @user.sign_up_reason = params[:spree_user][:sign_up_reason]

        EmailCapture.new({},
          email: @user.email,
          first_name: @user.first_name,
          last_name: @user.last_name,
          current_sign_in_ip: request.remote_ip,
          landing_page: session[:landing_page],
          utm_params: session[:utm_params],
          site_version: current_site_version.name,
          form_name: 'create_account').capture

        @user.generate_spree_api_key!
        
        sign_in("spree_user", @user)

        respond_with @user
      end

      def send_reset_password_email
        if !params[:email].present?
          render :json=>{:success=>false, :message=>"Missing arguments"}, :status=>422
          return
        end

        @user = Spree::User.find_for_authentication(:email => params[:email])

        if @user.present?
          @user.send_reset_password_instructions
          render :json=>{:success=>true, :message=>"Email sent"}, :status=>200
          return
        end

        render :json=>{:success=>false, :message=>"Email not found"}, :status=>404
      end

      def reset_password
        if !params[:token].present? or !params[:password].present? or params[:password].blank?
          render :json=>{:success=>false, :message=>"Missing arguments"}, :status=>422
          return
        end

        @user = Spree::User.find_for_database_authentication(:reset_password_token => params[:token])
        if @user.present? and @user.reset_password_period_valid?
          puts("hhhhhhhhhhhhhhhh")
          puts(@user.encrypted_password)
          if @user.reset_password!(params[:password], params[:password])
            sign_in("spree_user", @user)
            respond_with @user
            return
          end
        end

        render :json=>{:success=>false, :message=>"Invalid arguments"}, :status=>401
      end

      def change_password
        if !params[:old_password].present? or params[:old_password].blank? or !params[:password].present? or params[:password].blank? or !params[:email].present?
          render :json=>{:success=>false, :message=>"Missing arguments"}, :status=>422
          return
        end

        @user = Spree::User.find_for_database_authentication(:email => params[:email])
        if @user.present? and @user.valid_password?(params[:old_password])
          if @user.reset_password!(params[:password], params[:password])
            respond_with @user
            return
          end
        end

        render :json=>{:success=>false, :message=>"Invalid arguments"}, :status=>401
      end

      def destroy
        session.clear
        render :json => {:success=>true}, status: 200
      end

      private

      def ensure_params_exist
        return unless params[:spree_user].blank?
        render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
      end

      def invalid_login_attempt
        warden.custom_failure!
        render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
      end

    end
  end
end
