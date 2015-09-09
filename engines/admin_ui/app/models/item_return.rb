class ItemReturn < ActiveRecord::Base
  has_many :events,
    class_name: 'ItemReturnEvent',
    foreign_key: 'item_return_uuid',
    primary_key: 'uuid'

  belongs_to :line_item, class_name: 'Spree::LineItem', inverse_of: :item_return

  STATES = %i( requested received in_negotiation in_dispute rejected approved refunded credit_note_issued )

  attr_accessible :uuid
  validates :uuid, uniqueness: true
end

