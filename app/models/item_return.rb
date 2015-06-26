class ItemReturn < ActiveRecord::Base
  has_many :events,
    class_name: 'ItemReturnEvent',
    foreign_key: 'item_return_uuid',
    primary_key: 'uuid'

  STATES = %i( requested received in_negotiation in_dispute rejected approved refunded credit_note_issued )

  attr_accessible :uuid
  validates :uuid, uniqueness: true
end

