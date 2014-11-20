class BridesmaidUserProfile < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :spree_user, class_name: 'Spree::User'

  attr_accessible :wedding_date, :status, :bridesmaids_count, :special_suggestions

  validates :spree_user, presence: true

  STATUSES = [
    [1, "I'm ready for a ring"],
    [2, "I'm engaged"],
    [3, "I'm a bride"],
    [4, "I'm the head bridesmaid"]
  ]

  serialize :additional_products, Array

  # NOTE: this is not a belongs_to relation, but we keep relation instead of getter
  belongs_to :color, class_name: 'Spree::OptionValue'

  def completed?
    status.present? && color.present?
  end

  def colors
    [color]
  end
end
