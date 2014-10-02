class CompetitionParticipation < ActiveRecord::Base
  belongs_to :spree_user,
             class_name: Spree::User

  before_create :generate_token

  private

  def generate_token
    loop do
      self.token = SecureRandom.urlsafe_base64(4)
      break unless self.class.exists?(token: self.token)
    end
  end
end
