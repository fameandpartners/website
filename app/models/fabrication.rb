class Fabrication < ActiveRecord::Base
  has_many :events,
    class_name: 'FabricationEvent',
    foreign_key: 'fabrication_uuid',
    primary_key: 'uuid'

  STATES = {
      purchase_order_placed:      'Your order has been received',
      purchase_order_confirmed:   'Your oder has been placed',
      fabric_assigned:            'Your fabric is being assigned',
      style_cut:                  'Your dress is in cutting',
      make:                       'Your dress is with a seamstress',
      qc:                         'Your dress is in quality control',
      shipped:                    'Shipped',
      customer_feedback_required: 'Customer Feedback Required'
  }.stringify_keys.freeze

  STATES_OPTIONS = STATES.invert.freeze

  belongs_to :line_item,  class_name: 'Spree::LineItem'

  validates :uuid,         uniqueness: true
  validates :line_item_id, presence: true

  attr_accessible :uuid
end
