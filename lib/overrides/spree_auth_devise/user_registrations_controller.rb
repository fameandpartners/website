Spree::UserRegistrationsController.class_eval do
  def new
    if params[:prom]
      session[:spree_user_return_to] = main_app.new_custom_dress_path
    end

    super
  end

  def create
    @user = build_resource(params[:spree_user])
    if resource.save
      set_flash_message(:notice, :signed_up)
      session[:spree_user_signup] = true
      associate_user

      redirect_to main_app.spree_user_thanks_path
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  def thanks
  end
end
