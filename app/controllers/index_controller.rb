class IndexController < ApplicationController
  layout 'redesign/application'

  def show
    @banner      = Spree::BannerBox.big_banner.where("css_class IS NULL OR css_class = '' OR css_class = ?", current_site_version.code).limit(10)
    @title       = [homepage_title, default_seo_title].join(' ')
    @description = default_meta_description
    if Features.active?(:maintenance)
      render :action => 'maintenance', :layout => 'redesign/maintenance'
    end
  end
end
