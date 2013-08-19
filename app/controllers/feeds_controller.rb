class FeedsController < ApplicationController
  def products
    @config = {
      title: "Fame & Partners",
      description: "Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.",
      domain: ActionMailer::Base.default_url_options[:host] || 'www.fameandpartners.com'
    }
    @items = get_items
  end

  private

  def get_items
    items = []
    Spree::Product.active.each do |product|
      product.variants.each do |variant|
        begin
          item = get_item_properties(product, variant)
          items.push(item)
        rescue
        end
      end
    end

    items
  end

  def get_item_properties(product, variant)
    size  = variant.dress_size.try(:presentation)
    color = variant.dress_color.try(:presentation)

    item = HashWithIndifferentAccess.new(
      variant: variant,
      product: product,
      availability: variant.in_stock? ? 'in stock' : 'out of stock',
      title: "#{product.name} - Size #{size} - Colour #{color}",
      description: product.description,
      price: "#{current_currency} #{variant.price_in(current_currency).display_price}",
      google_product_category: "Apparel & Accessories > Clothing > Dresses",
      id: "#{product.id.to_s}-#{variant.id.to_s}",
      group_id: product.id.to_s,
      color: color,
      size: size,
      weight: get_weight(product, variant)
    )
    item.update(get_images(product, variant))
  end

  # return image, additional images
  def get_images(product, variant)
    images = product.images
    images += variant.images
    if images.size > 0
      {
        image: get_absolute_image_url(images.first.attachment),
        images: images[1..-1].map{|i| get_absolute_image_url(i.attachment)}
      }
    else
      {
        image: get_absolute_image_url("/assets/noimage/product.png"),
        images: []
      }
    end
  end

  def get_weight(product, variant)
    if variant.weight.present?
      return variant.weight.present?
    elsif product.weight.present?
      return product.weight?
    elsif
      product.property("weight")
    end
  end

  def get_absolute_image_url(path)
    "http://#{@config[:domain]}#{path}"
  end
end
