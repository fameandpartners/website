class CompetitionParticipation < ActiveRecord::Base
  belongs_to :spree_user,
             class_name: Spree::User

  before_save on: :create do
    self.token = SecureRandom.hex
  end
end
