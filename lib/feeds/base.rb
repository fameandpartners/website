require_relative './exporter/base'
require_relative './exporter/getprice'
require_relative './exporter/google'
require_relative './exporter/google_flat_images'
require_relative './exporter/myshopping'
require_relative './exporter/shopping'

module Feeds
  class Base
    FEEDS =  %w(GoogleFlatImages Google Getprice Myshopping Shopping)

    attr_reader :config, :current_site_version

    def initialize(version_permalink)
      @current_site_version = SiteVersion.by_permalink_or_default(version_permalink)
      @config = {
        title:       'Fame & Partners',
        description: 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.',
        domain:       URI.join("http://#{ActionMailer::Base.default_url_options[:host]}", @current_site_version.to_param).to_s
      }
    end

    def export
      @items      = get_items
      @properties = get_properties

      FEEDS.each do |name|
        klass                         = Feeds::Exporter.const_get(name)
        exporter                      = klass.new
        exporter.items                = @items
        exporter.properties           = @properties
        exporter.config               = @config
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
      Spree::Product.active.includes(:variants).find_each(batch_size: 10) do |product|
        product.variants.each do |variant|
          begin
            item = get_item_properties(product, variant)
            if item['image'].present?
              items.push(item)
            end
          rescue StandartError => ex
            puts ex
          end
        end
      end

      items
    end

    def get_item_properties(product, variant)
      size  = variant.dress_size.try(:presentation)
      color = variant.dress_color.try(:presentation)
      price = variant.zone_price_for(current_site_version)

      # are we ever on sale?
      original_price = price.display_price #.display_price_without_discount
      sale_price     = price.display_price #.display_price_with_discount

      original_price = original_price.to_s.delete('$').to_f
      sale_price     = sale_price.to_s.delete('$').to_f

      if sale_price == original_price
        sale_price = 0
      end


      item = HashWithIndifferentAccess.new(
        variant:                 variant,
        variant_sku:             product.sku + variant.id.to_s,
        product:                 product,
        availability:            availability,
        title:                   "#{product.name} - Size #{size} - Colour #{color}",
        description:             product.description,
        price:                   original_price,
        sale_price:              sale_price,
        google_product_category: "Apparel & Accessories > Clothing > Dresses > Formal Gowns",
        google_product_types:    google_product_types(product),
        id:                      "#{product.id.to_s}-#{variant.id.to_s}",
        group_id:                product.id.to_s,
        color:                   color,
        size:                    size,
        weight:                  get_weight(product, variant)
      )

      item.update(get_images(product, variant))
    end

    # TH: on-demand means never having to say you're out-of-stock
    # variant.in_stock? ? 'in stock' : 'out of stock',
    def availability
      'in stock'
    end

    # return image, additional images
    def get_images(product, variant)
      images = product.images_for_variant(variant).to_a

      if images.present?
        images.sort_by!{ |i| i.position }
        cropped_images = images.select{ |i| i.attachment(:large).to_s.downcase.include?('crop') }
        cropped_images.sort_by!{ |i| i.position }

        front_crop = cropped_images.shift # pull the front image

        other_images = (cropped_images + images).uniq # prepend the crop to remainder of images
        other_images = other_images.map{|i| i.attachment(:large).to_s }

        {
          image: front_crop.present? ? front_crop.attachment(:large) : nil,
          images: other_images
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

    def google_product_types(product)
      taxons = product.taxons.includes(:taxonomy).sort_by{|t| [t.taxonomy.position, t.position]}
      taxons.map do |taxon|
        "Clothing & Accessories > Clothing > Dresses > #{ taxon.name }"
      end
    end
  end
end
