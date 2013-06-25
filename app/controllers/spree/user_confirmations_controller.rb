class Spree::UserConfirmationsController < Devise::ConfirmationsController
  def after_confirmation_path_for(resource_name, resource)
    root_path(user_addition_params)
  end
end
