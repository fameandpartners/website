class PagesController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  respond_to :html

  def fb_auth
    if params[:prom]
      session[:spree_user_return_to] = main_app.new_custom_dress_path
    elsif params[:quiz]
      session[:show_quiz] = true
    end

    if session[:sign_up_reason].blank?
      if params[:prom]
        session[:sign_up_reason] = 'custom_dress'
      elsif params[:quiz]
        session[:sign_up_reason] = 'style_quiz'
      end
    end

    redirect_to spree.spree_user_omniauth_authorize_url(:provider => :facebook)
  end
end
