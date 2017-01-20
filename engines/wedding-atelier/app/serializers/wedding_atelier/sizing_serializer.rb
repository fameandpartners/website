module WeddingAtelier
  class SizingSerializer < ActiveModel::Serializer
    has_many :sizes, serializer: WeddingAtelier::OptionValueSerializer
    has_many :heights
  end
end
