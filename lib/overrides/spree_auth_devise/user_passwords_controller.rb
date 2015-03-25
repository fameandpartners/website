Spree::UserPasswordsController.class_eval do

  layout 'redesign/application'

  before_filter :set_title

  def set_title
    @title = 'Reset Password'
  end

end
