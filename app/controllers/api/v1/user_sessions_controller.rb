module Api
  module V1
    class UserSessionsController < ApplicationController #< Devise::SessionsController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth
      # include Spree::Core::ControllerHelpers::Common
      # include Spree::Core::ControllerHelpers::Order

      ssl_required :new, :create, :destroy, :signup

      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        ensure_params_exist
        # authenticate_spree_user!

        resource = Spree::User.find_for_database_authentication(:login => params["spree_user"]["email"])
        return invalid_login_attempt unless resource

        if resource.valid_password?(params["spree_user"]["password"])
          sign_in("spree_user", resource)
          resource[:is_admin] = current_spree_user.try(:has_spree_role?, "admin")
          respond_with resource
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
        @user[:is_admin] = current_spree_user.try(:has_spree_role?, "admin")

        respond_with @user

      end

      def reset_password
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
