class PagesController < ApplicationController
  layout 'spree/layouts/spree_application'
  respond_to :html 

  def fb_auth
    if params[:prom]
      session[:sign_up_reason] = 'Custom dress'
      session[:spree_user_return_to] = main_app.step1_custom_dresses_path
    end

    redirect_to spree.user_omniauth_authorize_url(:provider => :facebook)
  end
end
