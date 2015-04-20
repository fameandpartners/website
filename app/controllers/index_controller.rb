class IndexController < ApplicationController
  layout 'redesign/application'

  def show
    @title = "Formal dresses online | Prom, Bridesmaids and Evening Gowns #{default_seo_title}"
    @description = default_meta_description
    if Features.active?(:maintenance)
      render :action => 'maintenance', :layout => 'redesign/maintenance'
    end
  end
end
