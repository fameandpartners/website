class Fabrication < ActiveRecord::Base
  has_many :events,
    class_name: 'FabricationEvent',
    foreign_key: 'fabrication_uuid',
    primary_key: 'uuid'

  STATES = {
      purchase_order_placed:    'PO Placed',
      purchase_order_confirmed: 'PO Confirmed',
      fabric_assigned:          'Fabric Assigned',
      style_cut:                'Style Cut',
      make:                     'Make',
      qc:                       'QC',
      shipped:                  'Shipped'
  }.stringify_keys.freeze

  STATES_OPTIONS = STATES.invert.freeze

  belongs_to :line_item,  class_name: 'Spree::LineItem'

  validates :uuid,         uniqueness: true
  validates :line_item_id, presence: true

  attr_accessible :uuid
end

