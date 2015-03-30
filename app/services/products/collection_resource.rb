# should be loaded automatically
#require File.join(Rails.root, 'app', 'presenters', 'products', 'collection_presenter.rb')
# Usage:
#  Products::CollectionResource.new
#    site_version: current_site_version,
#    collection:     params[:collection], # range!
#    style:          params[:style],
#    event:          params[:event],
#    color_group:    # color group, will be search by its members
#    color:          # exact color, will be searched with similarities
#    bodyshape:      params[:bodyshape],
#    discount:       params[:sale] || params[:discount],
#    order:          params[:order]
#    limit:          # number of records
#    offset:         # number of records to skip

# NOTE:
# collection, contained 'some query' - not very correct semantically,
# so possible we should create base collection and inherit from it
# search collection & products collection
#
class Products::CollectionResource
  # include Repositories::CachingSystem

  attr_reader :site_version
  attr_reader :collection
  attr_reader :style
  attr_reader :edits
  attr_reader :event
  attr_reader :bodyshape
  attr_reader :color, :color_group
  attr_reader :discount
  attr_reader :query_string
  attr_reader :order
  attr_reader :limit
  attr_reader :offset

  def initialize(options = {})
    @site_version = options[:site_version] || SiteVersion.default
    @collection   = Repositories::Taxonomy.get_taxon_by_name(options[:collection])
    @style        = Repositories::Taxonomy.get_taxon_by_name(options[:style])
    @edits        = Repositories::Taxonomy.get_taxon_by_name(options[:edits])
    @event        = Repositories::Taxonomy.get_taxon_by_name(options[:event])
    @bodyshape    = Repositories::ProductBodyshape.get_by_name(options[:bodyshape])
    @color_group  = Repositories::ProductColors.get_group_by_name(options[:color_group])
    @color        = Repositories::ProductColors.get_by_name(options[:color])
    @discount     = prepare_discount(options[:discount])
    @query_string = options[:query_string]
    @order        = options[:order]
    @limit        = options[:limit]
    @offset       = options[:offset]
  end

  # what about ProductCollection class
  def read
    Products::CollectionPresenter.new(
      products:   products,
      total_products: total_products,
      collection: collection,
      style:      style,
      event:      event,
      bodyshape:  bodyshape,
      color:      color_group.try(:representative) || color,
      sale:       discount,
      query_string: query_string,
      order:      order,
      details:    details
    )
  end

  # cache_results :read


  private

    def details
      @details ||= begin
        Products::CollectionDetails.new(
          collection:     collection,
          style:          style,
          event:          event,
          edits:          edits,
          bodyshape:      bodyshape,
          color:          color_group.try(:representative) || color,
          discount:       discount,
          site_version:   site_version,
          fast_delivery:  fast_delivery?
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

      # if we have shown group ( through group.representative, it will be sent back )
      # ignore this case.
      # also, having ability to query group=black&color=white seems useless
      result[:color_ids] = []
      if color_group.present?
        result[:color_ids] += color_group.color_ids
      elsif color.present?
        result[:color_ids] += Repositories::ProductColors.get_similar(color.id, Similarity::Range::DEFAULT)
      end

      result[:discount] = discount if discount.present?
      result[:query_string] = query_string if query_string.present?
      result[:order] = order if order.present?
      result[:limit] = limit if limit.present?
      result[:offset] = offset if offset.present?

      result
    end

    def total_products
      query.json["hits"]["total"]
    end

    def products
      result = query.results.map do |color_variant|
        price = Repositories::ProductPrice.new(site_version: site_version, product_id: color_variant.product.id).read
        discount = Repositories::Discount.get_product_discount(color_variant.product.id)
        color = Repositories::ProductColors.read(color_variant.color.id)
        OpenStruct.new(
          id:             color_variant.product.id,
          name:           color_variant.product.name,
          color:          color_variant.color,
          images:         cropped_images(color_variant),
          price:          price,
          discount:       discount,
          fast_delivery:  color_variant.product.fast_delivery
        )
      end

      # apply custom order
      if order.blank? && color.blank? && style.blank?
        result = Products::ProductsSorter.new(products: result).sorted_products
      end

      result
    end

    # TODO - Consolidate with behaviour on app/helpers/landing_pages_helper.rb:24 #cropped_product_hoverable_images
    def cropped_images(color_variant)
      cropped_images = color_variant.images.select{ |i| i.large.to_s.downcase.include?('crop') }

      if cropped_images.blank?
        cropped_images = color_variant.images.select { |i| i.large.to_s.downcase.include?('front') }
      end

      cropped_images.sort_by!{ |i| i.position }
      cropped_images.collect{ |i| i.try(:large) }
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

    def fast_delivery?
      order == 'fast_delivery'
    end

    # def cache_key
    #   "collection-#{ site_version.permalink}-#{ taxon.permalink }"
    # end
end
