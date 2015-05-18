class IndexController < ApplicationController
  layout 'redesign/application'

  skip_before_filter :check_site_version
  before_filter :force_redirection_to_current_site_version

  def show
    @title = "Formal dresses online | Prom, Bridesmaids and Evening Gowns #{default_seo_title}"
    @description = default_meta_description
    if Features.active?(:maintenance)
      render :action => 'maintenance', :layout => 'redesign/maintenance'
    end
  end

  private

  def force_redirection_to_current_site_version
    param_site_version = params[:site_version] || SiteVersion.default.code

    if param_site_version != current_site_version.code
      redirect_to LocalizeUrlService.localize_url(request.url, current_site_version)
    end
  end
end
