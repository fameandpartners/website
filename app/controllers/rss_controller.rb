class RssController < ApplicationController

  def collections
    @collections = Spree::Taxon.published
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

end
