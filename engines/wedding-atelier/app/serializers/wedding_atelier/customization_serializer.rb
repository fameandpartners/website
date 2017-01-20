module WeddingAtelier
  class CustomizationSerializer < ActiveModel::Serializer
    has_many :silhouettes, serializer: WeddingAtelier::ProductSerializer
    has_many :colours, serializer: WeddingAtelier::OptionValueSerializer, root: :colors
    has_many :sizes, serializer: WeddingAtelier::OptionValueSerializer
    has_many :assistants, serializer: WeddingAtelier::UserSerializer
    has_many :heights
  end
end
