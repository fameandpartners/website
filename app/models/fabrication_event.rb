class FabricationEvent < ActiveRecord::Base
  include EventSourcedRecord::Event

  serialize :data, JSON

  belongs_to :fabrication,
    foreign_key: 'fabrication_uuid', primary_key: 'uuid'

  attr_accessible :line_item_id, :user_id, :user_name, :state

  event_type :creation do
    attributes :line_item_id
    validates  :line_item_id, presence: true
  end

  event_type :state_change do
    attributes :user_id, :user_name, :state

    validates :user_id,   presence: true
    validates :user_name, presence: true
    validates :state,     presence: true

    validates :state, inclusion: { in: Fabrication::STATES.stringify_keys.keys }
  end
end