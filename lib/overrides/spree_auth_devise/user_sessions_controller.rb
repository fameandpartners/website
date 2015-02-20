Spree::UserSessionsController.class_eval do
  layout 'redesign/application'
  
  def new
    if params[:quiz]
      session[:show_quiz] = true
    end

    super
  end
end
