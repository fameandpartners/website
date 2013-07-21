Spree::UserSessionsController.class_eval do
  def new
    if params[:quiz]
      session[:show_quiz] = true
    end

    super
  end
end
