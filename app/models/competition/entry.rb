class Competition::Entry < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :inviter, class_name: 'Spree::User'

  belongs_to :invitation, class_name: "Competition::Invite", foreign_key: 'invitation_id'

  scope :for_competition, lambda {|name| where(competition_name: name)}

  def create_additional_entry_for_inviter
    if self.invitation.present?
      additional_entry = Competition::Entry.new
      additional_entry.user = self.invitation.user
      additional_entry.inviter = self.user
      additional_entry.invitation_id = self.invitation.id
      additional_entry.master = false
      additional_entry.competition_name = self.competition_name
      additional_entry.save
    end
  end

  class << self
    def create_for(user, competition_name = nil, invitation = nil)
      competition_name ||= Competition.current

      entry = user.competition_entries.where(master: true).for_competition(competition_name).first
      return entry if entry.present?

      entry = Competition::Entry.new
      entry.user = user
      entry.competition_name = competition_name
      entry.master = true

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
