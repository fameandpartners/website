module WeddingAtelier
  class LineItemPersonalizationSerializer < ActiveModel::Serializer
    has_one :size, serializer: OptionValueSerializer
    has_one :color, serializer: OptionValueSerializer
    has_one :fabric
    has_one :length
    has_one :style
    has_one :fit

    def style
      object.customization_values.where(customisation_type: 'style').first
    end

    def fit
      object.customization_values.where(customisation_type: 'fit').first
    end

    def fabric
      object.customization_values.where(customisation_type: 'fabric').first
    end

    def length
      object.customization_values.where(customisation_type: 'length').first
    end

  end
end
