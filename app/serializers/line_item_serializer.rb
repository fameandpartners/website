class LineItemSerializer < ActiveModel::Serializer
  attributes :quantity, :currency, :id, :variant_id

  def price
    object.price.to_s
  end

  def product_name
    object.variant.product.name
  end

  def product_image
    object.variant.product.images.first
  end

  def money
    object.money.to_s
  end

  def count_on_hand
    object.variant.count_on_hand
  end
end
