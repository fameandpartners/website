module Personalization
  class RegistrationsController < BaseController
    skip_before_filter :authenticate_spree_user!
    before_filter :require_no_authentication!

    def new
      @user = Spree::User.new
    end

    def create
      @user = Spree::User.create_user(params[:user].extract!(:email, :first_name, :last_name, :phone).merge(sign_up_reason: 'customise_dress', validate_presence_of_phone: true))

      @user.build_style_profile do |object|
        object.typical_size = params[:user][:style_profile][:typical_size]
      end

      if @user.persisted?
        sign_in(:spree_user, @user)

        @user.style_profile.save

        # Marketing pixel
        session[:signed_up_just_now] = true

        Spree::UserMailer.welcome_with_password(@user).deliver

        redirect_to personalization_products_path(cf: 'custom-dresses-signup')
      end
    end

    private

    def require_no_authentication!
      redirect_to personalization_products_path if spree_user_signed_in?
    end
  end
end
