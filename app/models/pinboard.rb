class Pinboard < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', inverse_of: :pinboards
  has_many :items, class_name: 'PinboardItem', inverse_of: :pinboard

  attr_accessible :description, :event_date, :name, :purpose

  validates :user, presence: true

  def self.weddings
    where(purpose: 'wedding')
  end
end
