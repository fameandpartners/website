Spree::User.class_eval do
  attr_accessible :first_name, :last_name

  validates :first_name,
            :last_name,
            :presence => true

  after_create :send_welcome_email

  private

  def send_welcome_email
    Spree::UserMailer.welcome(self).deliver
  end
end
