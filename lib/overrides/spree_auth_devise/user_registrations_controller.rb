Spree::UserRegistrationsController.class_eval do
  def new
    if params[:prom]
      session[:spree_user_return_to] = main_app.step1_custom_dresses_path
    elsif params[:quiz]
      session[:show_quiz] = true
    elsif params[:personalization]
      session['personalization'] = true
    end

    if session[:sign_up_reason].blank?
      if params[:prom]
        session[:sign_up_reason] = 'custom_dress'
      elsif params[:quiz]
        session[:sign_up_reason] = 'style_quiz'
      elsif params[:workshop]
        session[:sign_up_reason] = 'workshop'
      end
    elsif params[:workshop]
      session[:sign_up_reason] = 'workshop'
    end

    super
  end

  def create
    @user = build_resource(params[:spree_user])

    if resource.new_record?
      resource.sign_up_via = Spree::User::SIGN_UP_VIA.index('Email')
      resource.sign_up_reason = session[:sign_up_reason]
    end

    if resource.save
      session.delete(:sign_up_reason)

      sign_in :spree_user, resource

      set_flash_message(:notice, :signed_up)
      session[:spree_user_signup] = true
      associate_user

      if session.delete('personalization')
        redirect_to main_app.personalization_path
      else
        redirect_to main_app.root_path({ci: 'signup'}.merge(params.slice(:cl)))
      end
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  def thanks
  end
end
