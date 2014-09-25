class CompetitionParticipation < ActiveRecord::Base
  belongs_to :spree_user,
             class_name: Spree::User

  before_create do
    self.token = SecureRandom.hex
  end
end
