module WishlistItemsHelper
  def wishlist_item_color_image(item)
    if item.product_color_id.present?
      product_color_value = item.product.product_color_values.where(option_value_id: item.product_color_id).first
      product_color_value.images.first.attachment.url(:large)
    else
      dress_color = item.variant.dress_color
      if dress_color.present?
        product_color_value = dress_color.product_color_values.where(product_id: item.product.id).first
        product_color_value.images.first.attachment.url(:large)
      else
        item.product.images.first.attachment.url(:large)
      end
    end
  rescue
    'noimage/product.png'
  end
end
