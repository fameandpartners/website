module WeddingAtelier
  class CustomisationValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :image, :price, :discount

    def image
      object.image.presence || '/assets/noimage/small1.png'
    end
  end
end
