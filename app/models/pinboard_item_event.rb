class PinboardItemEvent < ActiveRecord::Base
  include EventSourcedRecord::Event

  serialize :data

  belongs_to :pinboard_item,
    foreign_key: 'pinboard_item_uuid', primary_key: 'uuid'

  event_type :creation do
    # attributes :user_id
    #
    # validates :user_id, presence: true
  end
end


