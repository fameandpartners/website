module WeddingAtelier
  class EventDressSerializer < ActiveModel::Serializer
    include ActionView::Helpers::NumberHelper
    attributes :id, :title, :likes_count, :author, :price, :liked, :images, :height, :height_group
    has_one :product, serializer: ProductSerializer
    has_one :color, serializer: OptionValueSerializer
    has_one :fabric, serializer: CustomisationValueSerializer
    has_one :fit, serializer: CustomisationValueSerializer
    has_one :style, serializer: CustomisationValueSerializer
    has_one :size, serializer: OptionValueSerializer
    has_one :length, serializer: CustomisationValueSerializer
    has_one :user, serializer: UserSerializer

    def title
      object.product.name
    end

    def author
      object.user.first_name
    end

    def price
      number_to_currency(object.product.price)
    end

    def liked
      object.liked_by?(scope.current_spree_user)
    end

    def height_group
      WeddingAtelier::Height.definitions.detect {|_, h| h.include?(object.height) }.first
    end
  end
end
