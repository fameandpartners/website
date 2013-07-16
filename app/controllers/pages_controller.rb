class PagesController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  respond_to :html

  def fb_auth
    if params[:prom]
      session[:sign_up_reason] = 'Custom dress'
      session[:spree_user_return_to] = main_app.new_custom_dress_path
    elsif params[:quiz]
      session[:show_quiz] = true
      session[:sign_up_reason] = 'Style quiz'
    end

    redirect_to spree.spree_user_omniauth_authorize_url(:provider => :facebook)
  end
end
