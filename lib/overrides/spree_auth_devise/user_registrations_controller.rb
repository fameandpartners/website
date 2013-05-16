Spree::UserRegistrationsController.class_eval do
  def new
    if params[:prom]
      session[:spree_user_return_to] = main_app.new_custom_dress_path
    end

    super
  end
end
