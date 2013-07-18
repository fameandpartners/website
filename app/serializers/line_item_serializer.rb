class LineItemSerializer < ActiveModel::Serializer
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include Spree::ProductsHelper

  attributes :quantity, :currency, :id, :variant_id

  attributes :count_on_hand,
    :image_small,
    :money, 
    :price,
    :product_name,
    :product_permalink,
    :product_description,
    :product_color,
    :product_size

  def price
    object.price.to_s
  end

  def product_name
    object.variant.product.name
  end

  def image_small
    if image = object.variant.product.images.first
      image.attachment(:small)
    else
      '/assets/noimage/product.png'
    end
  end

  def money
    object.money.to_s
  end

  def count_on_hand
    object.variant.count_on_hand
  end

  def product_permalink
    object.variant.product.permalink
  end

  def product_description
    line_item_description(object.variant)
  end

  def product_color
    object.variant.dress_color.try(:name) || ""
  end

  def product_size
    object.variant.dress_size.try(:name) || ''
  end
end
