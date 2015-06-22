Devise::OmniauthCallbacksController.class_eval do
  def after_omniauth_failure_path_for(scope)
    new_spree_user_session_path
  end
end
