class CompetitionEntry < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :inviter, class_name: 'Spree::User'

  belongs_to :invitation, class_name: "CompetitionInvitation"

  def create_additional_entry_for_inviter
    if self.invitation.present?
      additional_entry = CompetitionEntry.new
      additional_entry.user = self.invitation.user
      additional_entry.invitation_id = self.invitation.id
      additional_entry.master = false
      additional_entry.save
    end
  end

  class << self
    def create_for(user, invitation = nil)
      entry = CompetitionEntry.new
      entry.user = user

      if invitation.present?
        entry.inviter = invitation.user
        entry.invitation = invitation
      end

      if entry.save
        entry.create_additional_entry_for_inviter
      end

      entry
    end
  end
end
