class ItemReturn < ActiveRecord::Base
  has_many :events,
    class_name: 'ItemReturnEvent',
    foreign_key: 'item_return_uuid',
    primary_key: 'uuid'

  has_one :item_return_label

  belongs_to :line_item, class_name: 'Spree::LineItem', inverse_of: :item_return
  belongs_to :return_request, foreign_key: :request_id, class_name: 'ReturnRequestItem'

  STATES = %i( requested received in_negotiation in_dispute rejected approved refunded credit_note_issued unknown )

  RECEIVE_LOCATIONS = %w[AU US]

  attr_accessible :uuid
  validates :uuid, uniqueness: true

  scope :incomplete, where('refund_status IS NULL OR refund_status != ?', 'Complete')
  scope :refund_queue, incomplete.where(acceptance_status: 'approved', order_payment_method: 'Pin')

  def return_label
    if item_return_label.nil?
      build_item_return_label()
    end

    item_return_label
  end

  private

  def build_item_return_label
    order = self.line_item.order

    label = Newgistics::ShippingLabel.new(
      order.user_first_name,
      order.user_last_name,
      order.email,
      self.id
    )

    self.item_return_label = ItemReturnLabel.new(
      :carrier => label.carrier,
      :label_image_url => label.label_image_url,
      :label_pdf_url => label.label_pdf_url,
      :label_url => label.label_url,
      :carrier => label.carrier
    )

    self.save
  end

end

