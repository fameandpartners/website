module WeddingAtelier
  class CustomisationValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :image, :price, :discount, :customisation_type

    def image
      # TODO: This method may not be needed, remove it.
      object.image.presence || '/assets/noimage/small1.png'
    end
  end
end
