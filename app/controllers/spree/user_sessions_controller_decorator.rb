Spree::UserSessionsController.class_eval do
  layout 'redesign/application'

  respond_to :json
  skip_before_filter :verify_authenticity_token
  before_filter :store_path_to_return, only: [:new, :destroy]

  def create
    binding.pry
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
          binding.pry
          flash.now[:error] = t('devise.failure.invalid')
          render :new
        }
        format.json {
          binding.pry
          render json: { error: true }
        }
      end
    end
  end

  private

    def after_sign_out_path_for(resource_or_scope)
      session[:spree_user_return_to].present? ? session[:spree_user_return_to] : super(resource_or_scope)
    end

    def store_path_to_return
      if params[:return_to]
        set_after_sign_in_location(params[:return_to])
      elsif params[:spree_user_return_to]
        set_after_sign_in_location(params[:spree_user_return_to])
      elsif is_user_came_from_current_app
        set_after_sign_in_location(request.referrer)
      end
    end
end
