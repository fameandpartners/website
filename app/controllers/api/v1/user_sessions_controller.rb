module Api
  module V1
    class UserSessionsController < ApplicationController #< Devise::SessionsController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth
      # include Spree::Core::ControllerHelpers::Common
      # include Spree::Core::ControllerHelpers::Order

      ssl_required :new, :create, :destroy, :signup, :reset_password

      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        ensure_params_exist
        # authenticate_spree_user!

        @user = Spree::User.find_for_database_authentication(:login => params["spree_user"]["email"])
        return invalid_login_attempt unless @user

        if @user.valid_password?(params["spree_user"]["password"])
          sign_in("spree_user", @user)
          @user[:is_admin] = @user.admin?
          respond_with @user
          return
        end

        invalid_login_attempt
      end

      def signup
        if !ensure_user_params_exist
          render :json=>{:success=>false, :message=>"Missing arguments"}, :status=>422
          return
        end

        @user = Spree::User.find_by_email(params[:spree_user][:email])

        if @user.present?
          render :json=>{:success=>false, :message=>"User already exists"}, :status=>401
          return
        end

        @user = Spree::User.new(params[:spree_user])
        
        if !@user.save
          render :json=>{:success=>false, :message=>"User already exists"}, :status=>401
          return
        end

        @user.generate_spree_api_key!
        sign_in("spree_user", @user)
        @user[:is_admin] = @user.admin?

        respond_with @user

      end

      def send_reset_password_email
        if !params[:email].present?
          render :json=>{:success=>false, :message=>"Missing arguments"}, :status=>422
          return
        end

        @user = Spree::User.find_by_email(params[:email])

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
        # @user = Spree::User.find_for_database_authentication(:login => params[:email])
        if @user.present? and @user.reset_password_period_valid?
        # if @user.present?
          if @user.reset_password!(params[:password], params[:password])
            sign_in("spree_user", @user)
            @user[:is_admin] = @user.admin?
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

      def ensure_user_params_exist
          params[:spree_user].present? and 
          params[:spree_user][:email].present? and 
          params[:spree_user][:password].present? and 
          params[:spree_user][:password_confirmation].present? and 
          params[:spree_user][:first_name].present? and 
          params[:spree_user][:last_name].present?
      end

    end
  end
end
