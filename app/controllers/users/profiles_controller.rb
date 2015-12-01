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
    if @user.update_profile(params[:profile])
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
    if @user.update_profile_image(params[:image])
      render json: { image: @user.image, success: true }
    else
      render json: { success: false }
    end
  end
end
