module WeddingAtelier
  class CustomisationValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :price, :discount, :customisation_type, :pov
  end
end
