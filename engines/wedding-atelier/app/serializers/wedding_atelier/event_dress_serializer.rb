module WeddingAtelier
  class EventDressSerializer < ActiveModel::Serializer
    attributes :id, :title, :love_count, :author, :price
    has_one :product
    has_one :color, serializer: OptionValueSerializer

    def title
      object.product.name
    end

    def author
      object.user.first_name
    end

    def price
      100
    end

    def love_count
      1
    end

    def image
      image = object.product.images.first
      image.present? ? image.attachment(:small) : '/assets/wedding-atelier/customization_experience/default_dress.png'
    end
  end
end
