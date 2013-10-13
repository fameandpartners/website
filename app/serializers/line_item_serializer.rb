class LineItemSerializer < ActiveModel::Serializer
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include Spree::ProductsHelper

  attributes :quantity, :currency, :id, :variant_id

  attributes :count_on_hand,
    :image_small,
    :product_image,
    :money,
    :money_without_discount,
    :price,
    :product_name,
    :product_permalink,
    :product_description,
    :product_color,
    :product_size

  has_one :personalization

  def price
    object.price.to_s
  end

  def product_name
    object.variant.product.name
  end

  def image_small
    image.present? ? image.attachment(:small) : '/assets/noimage/product.png'
  end

  def product_image
    image.present? ? image.attachment(:product) : '/assets/noimage/product.png'
  end

  def image
    @image ||= object.variant.product.images.first
  end

  def money
    object.money.to_s
  end

  def money_without_discount
    object.in_sale? ? object.money_without_discount.to_s : nil
  end

  def count_on_hand
    object.variant.count_on_hand
  end

  def product_permalink
    object.variant.product.permalink
  end

  # copy pasted code from spree line_item_description
  # due to problems with t method
  def product_description
    description = object.variant.product.description
    if description.present?
      truncate(strip_tags(description.gsub('&nbsp;', ' ')), :length => 100)
    else
      I18n.t(:product_has_no_description)
    end
  end

  def product_color
    object.variant.dress_color.try(:name) || ""
  end

  def product_size
    object.variant.dress_size.try(:name) || ''
  end
end
