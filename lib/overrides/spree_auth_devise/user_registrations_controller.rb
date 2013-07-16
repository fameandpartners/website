Spree::UserRegistrationsController.class_eval do
  def new
    if params[:prom]
      session[:sign_up_reason] = 'Custom dress'
      session[:spree_user_return_to] = main_app.new_custom_dress_path
    elsif params[:quiz]
      session[:show_quiz] = true
      session[:sign_up_reason] = 'Style quiz'
    end

    super
  end

  def create
    @user = build_resource(params[:spree_user])

    custom_fields = {
      :Signupreason => sign_up_reason_for_campaign_monitor,
      :Signupdate => Date.today.to_s
    }

    if resource.new_record?
      resource.sign_up_via = Spree::User::SIGN_UP_VIA.index('Email')
    end

    if resource.save
      CampaignMonitor.delay.synchronize(resource.email, resource, custom_fields)

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
