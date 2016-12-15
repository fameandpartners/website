module WeddingAtelier
  class CustomizationSerializer < ActiveModel::Serializer
    has_many :silhouettes, serializer: WeddingAtelier::ProductSerializer
    has_many :fabrics, serializer: WeddingAtelier::OptionValueSerializer
    has_many :colours, serializer: WeddingAtelier::OptionValueSerializer
    has_many :sizes, serializer: WeddingAtelier::OptionValueSerializer
    has_many :lengths, serializer: WeddingAtelier::OptionValueSerializer
    has_many :assistants, serializer: WeddingAtelier::UserSerializer
    has_many :heights
    has_one  :site_version, serializer: SiteVersionSerializer
  end
end
