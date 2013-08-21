class CompetitionInvitation < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'

  before_create :generate_token

  validates :email, format: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  attr_accessible :email, :name, :invitation_type

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless CompetitionInvitation.where(token: random_token).exists?
    end
  end

  class << self
    def send_from(sender, name, email)
      invitation = sender.invitations.build(
        name: name,
        email: email,
        invitation_type: 'individual'
      )
      if invitation.save
        Spree::CompetitionsMailer.invite(invitation).deliver
      end
    end
  end
end
