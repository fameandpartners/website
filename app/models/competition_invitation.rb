class CompetitionInvitation < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'

  before_create :generate_token

  validates :email, format: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, if: :personal?

  attr_accessible :email, :name, :invitation_type

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless CompetitionInvitation.where(token: random_token).exists?
    end
  end

  def personal?
    self.invitation_type == 'individual' || self.invitation_type == 'personal'
  end

  class << self
    def send_from(sender, name, email)
      invitation = sender.invitations.build(
        name: name,
        email: email,
        invitation_type: 'personal'
      )
      if invitation.save
        Spree::CompetitionsMailer.invite(invitation).deliver
      end
    end

    def fb_invitation_from(user)
      user.invitations.where(invitation_type: 'broadcast').first_or_create
    end
  end
end
