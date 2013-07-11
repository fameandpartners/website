Spree::Admin::UsersController.class_eval do
  before_filter :clear_params, only: [:update]

  private

  # XXX: this is a hack for devise that removes empty password and password confirmation
  # values in order to save user without password change
  def clear_params
    if params[:user].present? && !params[:user][:password].nil?
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end
  end
end
