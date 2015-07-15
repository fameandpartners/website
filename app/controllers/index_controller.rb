class IndexController < ApplicationController
  layout 'redesign/application'

  before_filter :guarantee_site_version_cookie
  before_filter :force_redirection_to_current_site_version

  def show
    @banner = Spree::BannerBox.big_banner.where("css_class IS NULL OR css_class = '' OR css_class = ?", current_site_version.code).limit(10)
    @title = "#{Spree::Config[:homepage_title]} #{default_seo_title}"
    @description = default_meta_description
    if Features.active?(:maintenance)
      render :action => 'maintenance', :layout => 'redesign/maintenance'
    end
  end

  def guarantee_site_version_cookie
    cookies[:site_version] ||= site_version_param
  end

  def force_redirection_to_current_site_version
    if cookies[:site_version] != site_version_param
      site_version = SiteVersion.by_permalink_or_default(cookies[:site_version])
      redirect_to LocalizeUrlService.localize_url(request.url, site_version)
    end
  end
end
