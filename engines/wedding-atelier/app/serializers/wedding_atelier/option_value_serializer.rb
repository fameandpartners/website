module WeddingAtelier
  class OptionValueSerializer < ActiveModel::Serializer
    attributes :id, :name, :presentation, :value, :image, :price

    def image
      object.image.present? ? object.image : '/assets/noimage/small1.png'
    end

    def price
      BigDecimal.new(12)
    end
  end
end
