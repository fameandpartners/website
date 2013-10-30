class SiteVersionsController < ApplicationController
  def show
    site_version = params[:id].to_s.downcase == 'au' ? 'au' : 'us'
    self.selected_site_version = site_version

    redirect_back_or_default(root_url)
  end
end
