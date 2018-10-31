Spree::Admin::BaseController.class_eval do
  include ::Spree::Admin::SkipSpreeCommerceAlerts

  def url_options
    options = super
    options.except(:site_version, 'site_version')
  end

  def default_url_options
    {}
  end

  def spree_login_path
    Features.active?(:new_account)  ? '/account/login' : spree.login_path
  end

end
