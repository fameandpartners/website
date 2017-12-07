class Users::ProfilesController < Users::BaseController
  before_filter :load_user

  def show
    @title = 'My Account Settings'

    respond_with(@user) do |format|
      format.html {}
      format.js   {}
    end
  end

  def update
    old_email = @user.email
    if @user.update_profile(params[:profile])
      # EmailCapture.new({ service: :mailchimp }, email: @user.email,
      #                              previous_email: old_email, first_name: @user.first_name,
      #                              last_name: @user.last_name, current_sign_in_ip: request.remote_ip,
      #                              landing_page: session[:landing_page], utm_params: session[:utm_params],
      #                              site_version: current_site_version.name, form_name: 'account_update').capture
      if old_email != @user.email
        update_user_orders
      end
      respond_with(@user) do |format|
        format.html { redirect_to profile_path }
        format.js   { render 'users/profiles/success_update' }
      end
    else
      respond_with(@user) do |format|
        format.html { render action: 'show' }
        format.js   { render 'users/profiles/failure_update' }
      end
    end
  end

  def update_image
    # TODO: Temporarily disabling image file upload due to https://imagetragick.com/

    # if @user.update_profile_image(params[:image])
    #   render json: { image: @user.image, success: true }
    # else
    #   render json: { success: false }
    # end

    render json: { success: false }
  end

  private

  def update_user_orders
    @user.orders.each do |order|
      order.email = @user.email
      order.save
    end
  end
end
