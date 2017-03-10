module WeddingAtelier
  class CustomisationValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :price, :discount, :customisation_type, :point_of_view
  end
end
