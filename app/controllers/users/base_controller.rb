class Users::BaseController < ApplicationController
  before_filter :authenticate_spree_user!, :except => :check_email_exist

  layout 'redesign/application'

  respond_to :js, :html

  def check_email_exist
    render json: { email: params[:spree_user][:email], success: Spree::User.where(email: params[:spree_user][:email]).present? }
  end

  private

  def load_user
    @user = try_spree_current_user
    @user.clean_up_passwords if @user.respond_to?(:clean_up_passwords)
  end
end
