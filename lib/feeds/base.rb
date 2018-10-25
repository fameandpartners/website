module Feeds
  class Base
    FEEDS =  %w(Google Shopstyle)
    attr_reader :config, :current_site_version, :logger

    def initialize(version_permalink, logger: default_logger)
      @current_site_version = SiteVersion.by_permalink_or_default(version_permalink)
      @logger = logger

      @config = {
        title:       'Fame & Partners',
        description: 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.',
        domain:       domain_url
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

    def product_scope
      Spree::Product.active
    end

    def get_items
      items = []
      index = 0
      total = product_scope.count

      ot_fabric = Spree::OptionType.find_by_name("dress-fabric-color")
      logger.info "Fetching Items. Total: #{total}"

      # product_scope.each do |product|
      product_scope.find_each(batch_size: 10) do |product|
        index += 1
        logger_product_name  = "Product: #{product.name}"
        logger_product_count = "[#{index}/#{total}]"
        logger.info "#{logger_product_count.ljust(10)} | #{logger_product_name}"

        if !product.fabric_products.empty?
          product.fabric_products.each do |product_fabric_value|
            color = product_fabric_value.fabric.option_value
            fabric = product_fabric_value.fabric

            if !product_fabric_value.images.present? 
              logger.error "id  -  | No Images!"
              next
            end

            item = get_item_properties(product, color, fabric, product_fabric_value.images)
            items.push(item)
          end
        else
          product.product_color_values.active.each do |product_color_value|
            color = product_color_value.option_value

            if !product_color_value.images.present? 
              logger.error "id  -  | No Images!"
              next
            end
          
            item = get_item_properties(product, color, nil, product_color_value.images)
            items.push(item)
          end
        end
      end
      items
    end


    # TODO: Feed item is so important, that should be extracted to a separate class...
    def get_item_properties(product, color, fabric, images)
      color_presentation = color.presentation
      size_presentation  = current_site_version.name == "USA" ? 'US 0-20' : 'AU 4-26'
      price              = product.site_price_for(current_site_version)

      # are we ever on sale?
      original_price = price.display_price.to_html(symbol: false) #.display_price_without_discount

      sale_price = nil
      if product.discount
        sale_price = price.apply(product.discount)
        sale_price = sale_price.display_price.to_html(symbol: false)
      end

      pid = Spree::Product.format_new_pid(product.sku, fabric&.name || color.name, [])

      item = HashWithIndifferentAccess.new(
        # variant:                 variant,
        path:                    helpers.collection_product_path(product, color: (fabric&.name || color.name)),
        variant_sku:             pid,
        product:                 product,
        product_name:            product.name,
        product_sku:             product.sku,
        availability:            availability,
        title:                   "#{color_presentation} #{product.name} Dress",
        description:             helpers.strip_tags(product.description),
        price:                   original_price,
        sale_price:              sale_price,
        google_product_category: 'Apparel & Accessories > Clothing > Dresses > Formal Gowns',
        id:                      pid,
        group_id:                product.sku,
        color:                   color_presentation,
        size:                    size_presentation,
        weight:                  '',#get_weight(product, variant),
        fabric:                  fabric&.material || product.property('fabric')
      )

      # Event, Style and Lookbook
      item.update get_taxons(product)

      # Images
      item.update get_images(images)
    end

    # TH: on-demand means never having to say you're out-of-stock
    # variant.in_stock? ? 'in stock' : 'out of stock',
    def availability
      'in stock'
    end

    # return image, additional images
    def get_images(images)
      if images.present?
        images = images.select {|img| img.position.present?}
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
      product_taxons    = Spree::Taxon.order('spree_taxons.position').where(id: product.taxon_ids)
      product_events    = product_taxons.published.from_event_taxonomy
      product_styles    = product_taxons.published.from_style_taxonomy
      product_lookbooks = product_taxons.from_edits_taxonomy

      {
        taxons:    product_taxons.map(&:name),
        events:    product_events.map(&:name),
        styles:    product_styles.map(&:name),
        lookbooks: product_lookbooks.map(&:name)
      }
    end


    private def domain_url
      url = ENV.fetch('APP_HOST') { 'https://www.fameandpartners.com' }
      detector.site_version_url(url, current_site_version).chomp('/')
    end

    private def detector
      UrlHelpers::SiteVersion::Detector.detector
    end
  end
end
