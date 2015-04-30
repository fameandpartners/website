class Fabrication < ActiveRecord::Base
  has_many :events,
    class_name: 'FabricationEvent',
    foreign_key: 'fabrication_uuid',
    primary_key: 'uuid'

  STATES = {
      purchase_order_placed:      'PO Placed',
      purchase_order_confirmed:   'PO Assigned',
      fabric_assigned:            'Fabric Assigned',
      style_cut:                  'Style Cutting',
      make:                       'Making',
      qc:                         'QC',
      shipped:                    'Shipped',
      customer_feedback_required: 'Customer Feedback'
  }.stringify_keys.freeze

  STATE_ORDER = [
      :customer_feedback_required,
      :purchase_order_placed,
      :purchase_order_confirmed,
      :fabric_assigned,
      :style_cut,
      :make,
      :qc,
      :shipped
  ]
  
  STATES_OPTIONS = STATES.invert.freeze

  belongs_to :line_item,  class_name: 'Spree::LineItem'

  validates :uuid,         uniqueness: true
  validates :line_item_id, presence: true

  attr_accessible :uuid
end
