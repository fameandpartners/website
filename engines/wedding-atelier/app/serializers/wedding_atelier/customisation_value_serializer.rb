module WeddingAtelier
  class CustomisationValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :image, :price, :discount, :customisation_type

    def image
      object.image.present? ? object.image : '/assets/noimage/small1.png'
    end
  end
end
