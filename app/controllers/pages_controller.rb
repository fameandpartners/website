class PagesController < ApplicationController
  layout 'spree/layouts/spree_application'
  respond_to :html 

  def fb_auth
    if params[:prom]
      session[:spree_user_return_to] = main_app.new_custom_dress_path
    end

    redirect_to spree.user_omniauth_authorize_url(:provider => :facebook)
  end
end
