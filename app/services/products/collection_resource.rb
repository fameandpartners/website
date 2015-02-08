# please, extract not user dependable data receiving to repo
class Products::Collection < OpenStruct; end

class Products::CollectionResource
  attr_reader :site_version
  attr_reader :style
  attr_reader :edits
  attr_reader :event
  attr_reader :bodyshape
  attr_reader :color
  attr_reader :sale
  attr_reader :order
  attr_reader :limit

  def initialize(options = {})
    @site_version = options[:site_version]
    @style        = Repositories::Taxonomy.get_taxon_by_name(options[:style]) 
    @edits        = Repositories::Taxonomy.get_taxon_by_name(options[:edits])
    @event        = Repositories::Taxonomy.get_taxon_by_name(options[:event])
    @bodyshape    = Repositories::ProductBodyshape.get_by_name(options[:bodyshape])
    @color        = Repositories::ProductColor.get_by_name(options[:color])
    @discount     = prepare_discount(options[:sale])
    @order        = options[:order]
    @limit        = options[:limit]
  end

  # what about ProductCollection class
  def read
    Products::Collection.new(
      filter:     filter,
      products:   products,
      banner:     banner,
      style:      style.try(:name),
      event:      event.try(:name),
      bodyshape:  bodyshape,
      color:      color.try(:presentation),
      sale:       sale,
      order:      order
    )
  end

  private

    def filter
      @filter   ||= Products::CollectionFilter.read
    end

    def banner
      taxon_banner = Spree::TaxonBanner.first
      OpenStruct.new(
        title: taxon_banner.title,
        description: taxon_banner.description
        #image: taxon_banner.image.present? ? taxon_banner.image.url : ''
      )
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
      @query ||= begin
        Search::ColorVariantsQuery.build(
          limit: limit
        )
      end
    end

    def products
      query.results.map do |color_variant|
        OpenStruct.new(
          id: color_variant.product.id,
          name: color_variant.product.name,
          image: color_variant.images.first.try(:large),
          price: Spree::Price.new(amount: color_variant.product.price, currency: current_currency).display_price
        )
      end
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
