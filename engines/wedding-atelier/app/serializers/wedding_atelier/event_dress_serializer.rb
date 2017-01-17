module WeddingAtelier
  class EventDressSerializer < ActiveModel::Serializer
    include ActionView::Helpers::NumberHelper
    attributes :id, :title, :likes_count, :author, :price, :liked, :images
    has_one :product, serializer: ProductSerializer
    has_one :color, serializer: OptionValueSerializer
    has_one :fabric, serializer: OptionValueSerializer
    has_one :fit, serializer: CustomisationValueSerializer
    has_one :style, serializer: CustomisationValueSerializer
    has_one :size, serializer: OptionValueSerializer
    has_one :length, serializer: OptionValueSerializer

    def title
      object.product.name
    end

    def author
      object.user
    end

    def price
      number_to_currency(object.product.price)
    end

    def liked
      object.liked_by?(scope.current_spree_user)
    end
  end
end
