Spree::UsersController.class_eval do
  def show
    # don't show default spree pages
    redirect_to main_app.profile_path
  end
end
