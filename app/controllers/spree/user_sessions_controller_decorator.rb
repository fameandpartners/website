Spree::UserSessionsController.class_eval do
  def create
    authenticate_spree_user!

    if spree_user_signed_in?
      respond_to do |format|
        format.html {
          flash[:success] = t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        }   
        format.js {
          user = spree_current_user
          render json: {
            ship_address: user.ship_address,
            bill_address: user.bill_address,
            user: { email: user.email, fullname: user.fullname }
          }.to_json
        }
      end 
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = t('devise.failure.invalid')
          render :new
        }   
        format.js {
          render json: { error: true }
        }   
      end 
    end 
  end
end
