class IndexController < ApplicationController
  layout 'redesign/application'

  def show
    @title = "Formal Dresses | Prom Dresses | Bridesmaid Dresses | Evening Gowns #{default_seo_title}"
    @description = default_meta_description
    if Features.active?(:maintenance)
      render :action => 'maintenance', :layout => 'redesign/maintenance'
    end
  end
end
