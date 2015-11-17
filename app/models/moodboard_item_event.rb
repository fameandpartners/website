class MoodboardItemEvent < ActiveRecord::Base
  include EventSourcedRecord::Event

  serialize :data

  belongs_to :moodboard_item,
    foreign_key: 'moodboard_item_uuid', primary_key: 'uuid'

  attr_accessible :moodboard_id, :user_id, :product_id, :color_id, :product_color_value_id, :variant_id
  event_type :creation do
    attributes :moodboard_id, :user_id, :product_id, :color_id, :product_color_value_id, :variant_id

    validates :user_id,    presence: true
    validates :product_id, presence: true
    validates :color_id,   presence: true
  end
end
