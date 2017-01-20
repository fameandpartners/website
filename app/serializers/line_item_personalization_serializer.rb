class LineItemPersonalizationSerializer < ActiveModel::Serializer
  attributes :size, :color, :customization_values

  def customization_values
    object.customization_values.map do |customization_value|
      {
        name: customization_value.name,
        presentation: customization_value.presentation,
        price: customization_value.price,
        type: customization_value.customisation_type
      }
    end
  end
end
