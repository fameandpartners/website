# should be loaded automatically
#require File.join(Rails.root, 'app', 'presenters', 'products', 'collection_presenter.rb')

class Products::CollectionResource
  attr_reader :site_version
  attr_reader :collection
  attr_reader :style
  attr_reader :edits
  attr_reader :event
  attr_reader :bodyshape
  attr_reader :color
  attr_reader :discount
  attr_reader :order
  attr_reader :limit

  def initialize(options = {})
    @site_version = options[:site_version] || SiteVersion.default
    @collection   = Repositories::Taxonomy.get_taxon_by_name(options[:collection]) 
    @style        = Repositories::Taxonomy.get_taxon_by_name(options[:style]) 
    @edits        = Repositories::Taxonomy.get_taxon_by_name(options[:edits])
    @event        = Repositories::Taxonomy.get_taxon_by_name(options[:event])
    @bodyshape    = Repositories::ProductBodyshape.get_by_name(options[:bodyshape])
    @color        = Repositories::ProductColors.get_by_name(options[:color])
    @discount     = prepare_discount(options[:discount])
    @order        = options[:order]
    @limit        = options[:limit]
  end

  # what about ProductCollection class
  def read
    Products::CollectionPresenter.new(
      products:   products,
      collection: collection,
      style:      style,
      event:      event,
      bodyshape:  bodyshape,
      color:      color,
      sale:       discount,
      order:      order,
      details:    details
    )
  end

  private

    def details
      @details ||= begin
        Products::CollectionDetails.new(
          collection: collection,
          style:      style,
          event:      event,
          edits:      edits,
          bodyshape:  bodyshape,
          color:      color,
          discount:   discount
        ).read
      end
    end

    def prepare_discount(value = nil)
      return nil if value.blank?
      if value.to_s == 'all'
        :all
      else
        value.to_s[/^\d+/].to_i
      end
    end

    def query
      @query ||= Search::ColorVariantsQuery.build(query_options)
    end

    def query_options
      result = { taxon_ids: [] }

      result[:taxon_ids].push(collection.id) if collection.present?
      result[:taxon_ids].push(style.id) if style.present?
      result[:taxon_ids].push(edits.id) if edits.present?
      result[:taxon_ids].push(event.id) if event.present?

      result[:body_shapes] = Array.wrap(bodyshape) if bodyshape.present?
      if color.present?
        result[:color_ids] = Repositories::ProductColors.get_similar(color.id, Similarity::Range::DEFAULT)
      end
      result[:discount] = discount if discount.present?

      result[:limit] = limit if limit.present?
      result[:order] = order if order.present?

      result
    end

    def products
      result = query.results.map do |color_variant|
        price = Repositories::ProductPrice.new(site_version: site_version, product_id: color_variant.product.id).read
        discount = Repositories::Discount.get_product_discount(color_variant.product.id)
        OpenStruct.new(
          id: color_variant.product.id,
          name: color_variant.product.name,
          color: color_variant.color.name,
          image: color_variant.images.first.try(:large),
          price: price,
          discount: discount
        )
      end

      # apply custom order 
      if order.blank? && color.blank? && style.blank?
        result = Products::ProductsSorter.new(products: result).sorted_products
      end

      result
    end

    def current_currency
      @current_currency ||= (site_version.try(:currency).to_s.downcase || 'usd')
    end

    # color variant stores price#id, not amount
    # possible, update index on price change will be easier&faster solution
    def get_zone_price(prices = {})
      price_id = (prices[current_currency] || prices['aud'] || prices['usd'])
      Spree::Price.find(price_id)
    end
end
