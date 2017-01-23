module WeddingAtelier
  class LineItemSerializer < ::LineItemSerializer
    has_one :personalization, serializer: WeddingAtelier::LineItemPersonalizationSerializer
  end
end
