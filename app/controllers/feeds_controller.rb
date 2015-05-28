class FeedsController < ApplicationController
  PRODUCT_COLOR_VALUE     = 'ProductColorValue'
  SPREE_VARIANT           = 'Spree::Variant'
  WEIGHT                  = 'weight'
  NO_IMAGE                = '/assets/noimage/product.png'
  IN_STOCK                = 'in stock'
  OUT_OF_STOCK            = 'out of stock'
  GOOGLE_PRODUCT_CATEGORY = 'Apparel & Accessories > Clothing > Dresses'

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

    products_scope = Spree::Product.active.includes(
      {master: :images},
      :properties,
      :product_properties,
      :product_color_values,
      {
        variants: [
          :images, :zone_prices, :prices, {option_values: :option_type}
        ]
      }
    )

    products_scope.find_in_batches(batch_size: 50) do |products|
      product_images = get_product_images(products)

      products.each do |product|
        product.variants.each do |variant|
          begin
            item = get_item_properties(product, variant, product_images)
            items.push(item)
          rescue
            # TODO: remove this as it's a bad practice to has such rescue in the code
          end
        end
      end
    end

    items
  end

  def get_product_images(products)
    # load images for all products and split them by products
    table_name = Spree::Image.quoted_table_name

    variants_including_master_ids_by_product = products.inject({}) do |result, product|
      result[product.id] = product.variants.select {|v| v.deleted_at.nil?}.map(&:id)
      result
    end

    variants_including_master_ids = variants_including_master_ids_by_product.values.flatten.uniq

    product_images = Spree::Image.includes(:viewable).where(
      "(#{table_name}.viewable_type = '#{PRODUCT_COLOR_VALUE}' AND #{table_name}.viewable_id IN (?))
        OR
      (#{table_name}.viewable_type = '#{SPREE_VARIANT}' AND #{table_name}.viewable_id IN (?))",
      products.map(&:product_color_value_ids).flatten.uniq, variants_including_master_ids
    ).inject({}) do |result, image|
      if image.viewable_type == PRODUCT_COLOR_VALUE
        products.select {|product| product.product_color_value_ids.include?(image.viewable_id)}.each do |product|
          result[product.id] ||= []
          result[product.id] << image
        end
      elsif image.viewable_type == SPREE_VARIANT
        products.select {|product| variants_including_master_ids_by_product[product.id].include?(image.viewable_id)}.each do |product|
          result[product.id] ||= []
          result[product.id] << image
        end
      end
      result
    end

    product_images.each do |product_id, images|
      images.sort_by!(&:position)
    end

    product_images
  end

  def get_item_properties(product, variant, product_images)
    size  = variant.dress_size.try(:presentation)
    dress_color_id = variant.dress_color.try(:id)
    color = variant.dress_color.try(:presentation)

    images = (product_images[product.id] || []) + variant.images

    image_by_color = images.detect do |image|
      image.viewable_type == PRODUCT_COLOR_VALUE && image.viewable.option_value_id == dress_color_id
    end

    item = HashWithIndifferentAccess.new(
      variant:                 variant,
      product:                 product,
      availability:            variant.in_stock? ? IN_STOCK : OUT_OF_STOCK,
      title:                   "#{product.name} - Size #{size} - Colour #{color}",
      description:             product.description,
      price:                   "#{current_currency} #{variant.zone_price_for(current_site_version).display_price}",
      google_product_category: GOOGLE_PRODUCT_CATEGORY,
      id:                      "#{product.id.to_s}-#{variant.id.to_s}",
      group_id:                product.id.to_s,
      color:                   color,
      size:                    size,
      weight:                  get_weight(product, variant)
    )
    item.update(images_data(image_by_color || images.first, images))
  end

  # return image, additional images
  def images_data(image, images)
    if images.size > 0
      {
        image: get_absolute_image_url(image.attachment),
        images: images[1..-1].map{|i| get_absolute_image_url(i.attachment)}
      }
    else
      {
        image: get_absolute_image_url(NO_IMAGE),
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
      # optimization in order ot remove N+1 queries
      # it's same as product.property("weight") call but use preloaded associations
      prop = product.properties.detect {|p| p.name == WEIGHT }
      if prop
        product.product_properties.detect {|prod_prop| prod_prop.property_id == prop.id}.try(:value)
      end
    end
  end

  def get_absolute_image_url(path)
    "http://#{@config[:domain]}#{path}"
  end
end
