class PinboardItem < ActiveRecord::Base

  belongs_to :pinboard, inverse_of: :items

  has_many :events,
    class_name: 'PinboardItemEvent',
    foreign_key: 'pinboard_item_uuid',
    primary_key: 'uuid'

  validates :uuid, uniqueness: true
end

