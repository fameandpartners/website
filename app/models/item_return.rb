class ItemReturn < ActiveRecord::Base
  has_many :events,
    class_name: 'ItemReturnEvent',
    foreign_key: 'item_return_uuid',
    primary_key: 'uuid'

  attr_accessible :uuid
  validates :uuid, uniqueness: true
end

