class Users::BaseController < ApplicationController
  before_filter :authenticate_spree_user!

  layout 'spree/layouts/spree_application'

  respond_to :js, :html

  private

  def load_user
    @user = try_spree_current_user
    @user.clean_up_passwords if @user.respond_to?(:clean_up_passwords)
  end
end
