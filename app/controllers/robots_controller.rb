class RobotsController < ActionController::Base
  respond_to :txt
  caches_page :show

  def show
    if Rails.env.production?
      render :production
    else
      render :staging
    end
  end
end