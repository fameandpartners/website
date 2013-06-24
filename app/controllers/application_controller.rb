class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def step1_custom_dresses_path(options = {})
    super options.merge(user_addition_params)
  end

  def step2_custom_dress_path(object, options = {})
    super object, options.merge(user_addition_params)
  end

  def success_custom_dress_path(object, options = {})
    super object, options.merge(user_addition_params)
  end

  helper_method :step1_custom_dresses_path,
                :step2_custom_dress_path,
                :success_custom_dress_path

  def user_addition_params
    if spree_user_signed_in?
      {
        :sign_up_via => Spree::User::SIGN_UP_VIA[current_spree_user.sign_up_via],
        :user_id => current_spree_user.id
      }
    else
      {}
    end
  end
end
