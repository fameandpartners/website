Spree::Admin::BaseController.class_eval do
  def url_options
    options = super
    options.except(:site_version, 'site_version')
  end

  def default_url_options
    {}
  end
end
