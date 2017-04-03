module Products
  class Presenter
    SCHEMA_ORG_IN_STOCK       = 'http://schema.org/InStock'
    SCHEMA_ORG_DISCONTINUED   = 'http://schema.org/Discontinued'
    META_DESCRIPTION_MAX_SIZE = 160

    attr_accessor :id, :master_id, :sku, :variant_skus, :name, :description,
                  :permalink, :is_active, :is_deleted, :images, :default_image, :price,
                  :discount, :recommended_products, :related_outerwear, :available_options, :taxons, :variants,
                  :moodboard, :fabric, :style_notes, :color_id, :color_name, :color,
                  :size_chart, :making_option_id, :fit, :size, :standard_days_for_making, :customised_days_for_making,
                  :default_standard_days_for_making, :default_customised_days_for_making,
                  :height_customisable, :fast_delivery, :render3d_images

    attr_reader   :product_type

    attr_writer :fast_making, :meta_description

    def initialize(opts)
      opts.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    module CollectionDressPresenter
      # Provide compatibility for old OpenStruct based presenters
      def to_h
        [:id, :name, :color, :images, :price, :discount, :fast_making, :fast_delivery].map { |key|
          [key , send(key)]
        }.to_h
      end
    end

    include CollectionDressPresenter

    def type
      'Dress'
    end

    def default_color_options
      colors&.default&.presence || []
    end

    def custom_color_options
      colors&.extra&.presence || []
    end

    def custom_color_price
      colors.default_extra_price.display_price
    end

    def colors
      @colors = available_options.colors
    end

    def custom_size_price
      sizes.default_extra_price.display_price
    end

    def sizes
      @sizes ||= available_options.sizes
    end

    def size_chart_data
      SizeChart.chart(size_chart)
    end

    def height_customisable?
      !! height_customisable
    end

    def customization_options
      customizable? ? customizations.all : []
    end

    def all_images
      collected_featured_images + collected_render3d_images
    end

    def collected_featured_images
      featured_images.collect do |img|
        { id: img.id, url: img.original, url_product: img.product, color_id: img.color_id, alt: name }
      end
    end

    def collected_render3d_images
      (render3d_images || []).collect do |img|
        {
          id: img.id,
          url: img.attachment.url(:original),
          url_product: img.attachment.url(:product),
          color_id: img.color_value_id,
          customization_id: img.customisation_value_id,
          alt: name
        }
      end
    end

    def featured_image
      @featured_image ||= featured_image_for_selected_color
    end

    def featured_image_for_selected_color
      color_image = images.select{ |i| i.color_id.to_i == color_id.to_i }.first
      color_image || featured_images.first
    end

    # featured images are not cropped
    def featured_images
      @featured_images ||= images.select{ |i| ! i.original.to_s.downcase.include?('crop') }
    end

    def cropped_images
      @cropped_images ||= images.select{ |i| i.original.to_s.downcase.include?('crop') }
    end

    def song
      moodboard.song_item
    end

    def celebrity
      moodboard.celebrity_item
    end

    def inspiration
      moodboard.items
    end

    def customizable?
      customisation_allowed? && customizations.present? && customizations.all.any?
    end

    def customizations
      @customizations ||= available_options.customizations
    end

    def making_options
      if fast_making_disabled?
        available_options.making_options.reject {|mo| mo.option_type.to_s.inquiry.fast_making? }
      else
        available_options.making_options
      end
    end

    def fast_making_disabled?
      Features.active?(:getitquick_unavailable)
    end

    def fast_making
      return false if fast_making_disabled?
      @fast_making
    end
    alias_method :fast_making?, :fast_making

    def default_color
      default_color_options.first&.name
    end

    def price_amount
      prices[:sale_amount].presence || prices[:original_amount]
    end

    def price_currency
      price.currency
    end

    def prices
      @prices ||= \
        if price.present?
          if discount&.amount.to_i > 0
            sale_price = price.apply(discount)
            discount_amount   = discount.amount
            discount_string = "#{discount.amount}%"
          elsif sale = Spree::Sale.last_sitewide.presence
            sale_price = sale.apply(price)
            discount_amount   = sale.discount_size
            discount_string = sale.discount_string
          end

          {
                   currency: price.currency,
            original_amount: price.amount,
                sale_amount: sale_price&.amount,
            discount_amount: discount_amount,
            original_string: price.display_price.to_s,
                sale_string: sale_price&.display_price&.to_s,
            discount_string: discount_string
          }
        end
    end

    # Until we have a more complex logic to invalidate sales and prices, it'll always be valid for one week
    def price_valid_until
      (Date.today + 1.week).iso8601
    end

    def schema_availability
      is_active ? SCHEMA_ORG_IN_STOCK : SCHEMA_ORG_DISCONTINUED
    end

    def use_auto_discount!(auto_discount)
      self.discount = [self.discount, auto_discount].compact.max_by{|i| i.amount.to_i }
    end

    def meta_title
      [
        color_name.to_s.titleize,
        name,
        type
      ].join(' ')
    end

    def meta_description
      (@meta_description.presence || fallback_meta_description).truncate(META_DESCRIPTION_MAX_SIZE)
    end

    def delivery_date
      delivery_date_obj_default               = Policies::ProjectDeliveryDatePolicy.new(self).delivery_date
      delivery_date_obj_no_customize_standard = Policies::ProjectDeliveryDatePolicy.new(self,false,"standard").delivery_date
      delivery_date_obj_no_customize_express  = Policies::ProjectDeliveryDatePolicy.new(self,false,"fast").delivery_date
      delivery_date_obj_customize_standard    = Policies::ProjectDeliveryDatePolicy.new(self,true,"standard").delivery_date
      delivery_date_obj_customize_express     = Policies::ProjectDeliveryDatePolicy.new(self,true,"fast").delivery_date
      text_default                            = Policies::ProjectDeliveryDatePolicy.delivery_date_text(delivery_date_obj_default)
      text_no_customize_standard              = Policies::ProjectDeliveryDatePolicy.delivery_date_text(delivery_date_obj_no_customize_standard)
      text_no_customize_express               = Policies::ProjectDeliveryDatePolicy.delivery_date_text(delivery_date_obj_no_customize_express)
      text_customize_standard                 = Policies::ProjectDeliveryDatePolicy.delivery_date_text(delivery_date_obj_customize_standard)
      text_customize_express                  = Policies::ProjectDeliveryDatePolicy.delivery_date_text(delivery_date_obj_customize_express)
      {text_default: text_default,text_no_customize_standard: text_no_customize_standard, text_no_customize_express: text_no_customize_express, text_customize_standard: text_customize_standard, text_customize_express: text_customize_express}
    end

    def product_category
      @product_type.presence || 'Apparel & Accessories > Clothing > Dresses'
    end

    private

    def customisation_allowed?
      discount.blank? || discount.customisation_allowed
    end

    def fallback_meta_description
      price_with_currency = [price.display_price, price.currency].join(' ')
      fabric_text         = fabric.to_s.squish

      [
        meta_title,
        price_with_currency,
        fabric_text
      ].join('. ')
    end
  end
end
