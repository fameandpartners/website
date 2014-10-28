require_relative './exporter/base'
require_relative './exporter/getprice'
require_relative './exporter/google'
require_relative './exporter/myshopping'
require_relative './exporter/shopping'

module Feeds
  class Base
    def initialize(version)
      @current_site_version = SiteVersion.find_by_permalink(version.to_s.downcase)
      @config = {
        title: "Fame & Partners",
        description: "Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.",
        domain: ActionMailer::Base.default_url_options[:host] || 'www.fameandpartners.com'
      }
    end

    def export
      @items = get_items
      @properties = get_properties

      %w( Getprice Google Myshopping Shopping ).each do |name|
        klass = Feeds::Exporter.const_get(name)
        exporter = klass.new
        exporter.items      = @items
        exporter.properties = @properties
        exporter.config     = @config
        exporter.current_site_version = @current_site_version
        exporter.export
      end
    end

    def self.export!(version)
      base = new(version)
      base.export
    end

    private

    def current_currency
      current_site_version.currency
    end

    def current_site_version
      @current_site_version
    end

    def get_properties
      properties = Hash[*
        Spree::Property.where(name: ['fabric', 'short_description']).map do |property|
          [property.id, property]
        end.flatten
      ]
      product_properties = Spree::ProductProperty.where(property_id: properties.keys)
      values = []

      product_properties.each do |product_property|
        product_id = product_property.product_id
        property   = properties[product_property.property_id]

        values[product_id] ||= HashWithIndifferentAccess.new
        values[product_id][property.name] = product_property.value
      end

      values
    end

    def get_items
      items = []
      Spree::Product.active.includes(:variants).each do |product|
        product.variants.each do |variant|
          begin
            item = get_item_properties(product, variant)
            if item['image'].present?
              items.push(item)
            end
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
        price: variant.zone_price_for(current_site_version).price,
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
      images = product.images_for_variant(variant).to_a

      if images.present?
        {
          image: absolute_image_url(images.first.attachment),
          images: images.from(1).map{|i| absolute_image_url(i.attachment) }
        }
      else
        {
          image: nil,
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

    def absolute_image_url(path)
      if Rails.env.production?
        path
      else
        "http://#{@config[:domain]}#{path}"
      end
    end
  end
end