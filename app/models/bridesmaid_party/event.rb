module BridesmaidParty
  class Event < ActiveRecord::Base
    self.table_name = :bridesmaid_party_events

    belongs_to :spree_user, class_name: 'Spree::User'
    has_many   :members

    #attr_accessible :wedding_date, :status, :bridesmaids_count, :special_suggestions
    attr_accessible :wedding_date, :status, :bridesmaids_count, :paying_for_bridesmaids

    validates :spree_user, presence: true

    STATUSES = [
      [1, "I'm ready for a ring"],
      [2, "I'm the bride"],
      [3, "I'm the Maid of Honour"],
      [4, "I'm the Mother of the Bride"]
    ]

    serialize :colors, Array
    serialize :additional_products, Array

    def completed?
      status.present? && colors.present?
    end

    def owned_by?(user)
      self.spree_user_id.present? && self.spree_user_id == user.try(:id)
    end
  end
end
