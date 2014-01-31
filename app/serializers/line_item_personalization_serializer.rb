class LineItemPersonalizationSerializer < ActiveModel::Serializer
  attributes :size, :color, :customization_values

  def customization_values
    object.customization_values.map do |customization_value|
      {
        name: customization_value.name,
        customisation_type: { presentation: customization_value.customisation_type.presentation  }
      }
    end
  end
end
