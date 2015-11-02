require_relative './exporter/base'
require_relative './exporter/cpc'
require_relative './exporter/polyvore'

module Feeds
  class Base
    FEEDS =  %w(CPC Polyvore)

    attr_reader :config, :current_site_version, :logger

    def initialize(version_permalink, logger: default_logger)
      @current_site_version = SiteVersion.by_permalink_or_default(version_permalink)
      @logger = logger

      @config = {
        title:       'Fame & Partners',
        description: 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.',
        domain:       URI.join("http://#{ActionMailer::Base.default_url_options[:host]}", @current_site_version.to_param).to_s
      }
    end

    def default_logger
      logger = Logger.new($stdout)

      logger.formatter = LogFormatter.terminal_formatter
      logger
    end

    def export
      @logger.info "Starting Feeds Export SITE (#{current_site_version.permalink})"
      @items      = get_items

      FEEDS.each do |name|
        logger.info("START Feed #{name}")
        klass                         = Feeds::Exporter.const_get(name)
        exporter                      = klass.new(logger: @logger)
        exporter.items                = @items
        exporter.config               = @config
        exporter.current_site_version = @current_site_version
        exporter.export
        logger.info("END Feed #{name}")
      end
    end

    def self.export!(version)
      base = new(version)
      base.export
    end

    private

    def helpers
      @helpers ||= Feeds::Helpers.new
    end

    def current_currency
      current_site_version.currency
    end

    def get_items
      logger.info 'Fetching Items'
      items = []
      Spree::Product.active.includes(:variants).find_each(batch_size: 10) do |product|
        logger.info "Product: #{product.name}"

        product.variants.each do |variant|
          begin
            item = get_item_properties(product, variant)

            has_images = item['image'].present?
            has_size   = item['size'].present?
            items.push(item) if has_images && has_size
          rescue StandardError => ex
            puts ex
          end
        end
      end

      items
    end

    def variant_size_data(spree_product:, spree_variant:)
      size_presentation = nil
      price             = spree_variant.site_price_for(current_site_version)

      # Extra size dresses should cost more than regular ones
      if (size = spree_variant.dress_size)
        product_size = Repositories::ProductSize.new(site_version: current_site_version, product: spree_product).read(size.id)

        size_presentation = product_size.presentation
        price.amount      += LineItemPersonalization::DEFAULT_CUSTOM_SIZE_PRICE if product_size.extra_price
      end

      { size_presentation: size_presentation, price: price }
    end

    # TODO: Feed item is so important, that should be extracted to a separate class...
    def get_item_properties(product, variant)
      variant_data = variant_size_data(spree_product: product, spree_variant: variant)

      color_presentation = variant.dress_color.try(:presentation)
      size_presentation  = variant_data[:size_presentation]
      price              = variant_data[:price]

      # are we ever on sale?
      original_price = price.display_price.to_html(symbol: false) #.display_price_without_discount

      sale_price = nil
      if product.discount
        sale_price = price.apply(product.discount)
        sale_price = sale_price.display_price.to_html(symbol: false)
      end

      item = HashWithIndifferentAccess.new(
        variant:                 variant,
        variant_sku:             product.sku + variant.id.to_s,
        product:                 product,
        product_name:            product.name,
        product_sku:             product.sku,
        availability:            availability,
        title:                   "#{color_presentation} #{product.name} Dress",
        description:             helpers.strip_tags(product.description),
        price:                   original_price,
        sale_price:              sale_price,
        google_product_category: 'Apparel & Accessories > Clothing > Dresses > Formal Gowns',
        id:                      "#{product.id.to_s}-#{variant.id.to_s}",
        group_id:                product.id.to_s,
        color:                   color_presentation,
        size:                    size_presentation,
        weight:                  get_weight(product, variant),
        fabric:                  product.property('fabric')
      )

      # Event, Style and Lookbook
      item.update get_taxons(product)

      # Images
      item.update get_images(product, variant)
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
          image: front_crop ? front_crop.attachment(:large) : nil,
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
      variant.weight || product.weight || product.property('weight')
    end

    def get_taxons(product)
      product_taxons    = Spree::Taxon.order('spree_taxons.position')
      product_events    = product_taxons.published.from_event_taxonomy.where(id: product.taxon_ids)
      product_styles    = product_taxons.published.from_style_taxonomy.where(id: product.taxon_ids)
      product_lookbooks = product_taxons.from_edits_taxonomy.where(id: product.taxon_ids)

      {
        taxons:    product_taxons.map(&:name),
        events:    product_events.map(&:name),
        styles:    product_styles.map(&:name),
        lookbooks: product_lookbooks.map(&:name)
      }
    end
  end
end
