class BridesmaidEventUserProfile < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :spree_user

  attr_accessible :wedding_date, :status, :bridesmaids_count

  validates :spree_user, presence: true
end
