Spree::User.class_eval do
  devise :confirmable

  attr_accessible :first_name, :last_name

  validates :first_name,
            :last_name,
            :presence => true

  after_create :send_welcome_email, :unless => :confirmation_required?

  has_attached_file :avatar

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  private

  def send_welcome_email
    Spree::UserMailer.welcome(self).deliver
  end
end
