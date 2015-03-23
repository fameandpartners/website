Spree::UserSessionsController.class_eval do
  layout 'redesign/application'

  before_filter :set_title

  def set_title
    @title = 'Login'
  end

  def new
    if params[:quiz]
      session[:show_quiz] = true
    end

    super
  end
end
