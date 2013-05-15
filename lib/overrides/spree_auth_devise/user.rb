Spree::User.class_eval do
  after_create :send_welcome_email

  private

  def send_welcome_email
    Spree::UserMailer.welcome(self).deliver
  end
end
