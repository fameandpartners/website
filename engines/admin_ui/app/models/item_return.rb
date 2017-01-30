class ItemReturn < ActiveRecord::Base
  has_many :events,
    class_name: 'ItemReturnEvent',
    foreign_key: 'item_return_uuid',
    primary_key: 'uuid'

  belongs_to :line_item, class_name: 'Spree::LineItem', inverse_of: :item_return
  belongs_to :return_request, foreign_key: :request_id, class_name: 'ReturnRequestItem'

  STATES = %i( requested received in_negotiation in_dispute rejected approved refunded credit_note_issued unknown )

  RECEIVE_LOCATIONS = %w[AU US]

  attr_accessible :uuid
  validates :uuid, uniqueness: true
  validates_presence_of :order_paid_currency

  before_validation :set_currency_from_line_item

  private

  def set_currency_from_line_item
    self.order_paid_currency ||= line_item.currency
  end
end

