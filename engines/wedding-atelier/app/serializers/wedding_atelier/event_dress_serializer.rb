module WeddingAtelier
  class EventDressSerializer < ActiveModel::Serializer
    has_one :product
    has_one :color, serializer: OptionValueSerializer
  end
end
