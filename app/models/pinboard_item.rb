class PinboardItem < ActiveRecord::Base
  attr_accessible :uuid

  belongs_to :pinboard, inverse_of: :items

  has_many :events,
    class_name: 'PinboardItemEvent',
    foreign_key: 'pinboard_item_uuid',
    primary_key: 'uuid'

  belongs_to :product_color_value
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :added_user, class_name: 'Spree::User'
  belongs_to :variant, class_name: 'Spree::Variant'


  validates :uuid, uniqueness: true, presence: true
end

