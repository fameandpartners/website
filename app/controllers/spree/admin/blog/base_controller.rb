class Spree::Admin::Blog::BaseController < Spree::Admin::BaseController
  private

  def current_ability
    @current_ability ||= Blog::Ability.new(try_spree_current_user)
  end

  def authorize_admin
    if respond_to?(:model_class, true) && model_class
      record = model_class
    else
      record = Object
    end
    authorize! action, record
  end
end
