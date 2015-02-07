# please, extract not user dependable data receiving to repo
class Products::CollectionResource
  attr_reader :site_version, :limit

  def initialize(options = {})
    @site_version = options[:site_version]
    @limit        = options[:limit]
  end

  def read
    OpenStruct.new(
      products: products,
      banner: banner
    )
  end

  private

    def banner
      taxon_banner = Spree::TaxonBanner.first
      OpenStruct.new(
        title: taxon_banner.title,
        description: taxon_banner.description
        #image: taxon_banner.image.present? ? taxon_banner.image.url : ''
      )
    end

    def products
      Array.new(limit) do |index|
        OpenStruct.new(
          id: 1000 + index,
          name: 'Mirrored Sea Dress',
          image: 'http://d1sd72h9dq237j.cloudfront.net/spree/products/8383/large/4B215-Black-1.jpg?1419659726',
          price: '$228'
        )
      end
    end

=begin
    def products
      query = Search::ColorVariantsQuery.build(
        limit: limit
      )
      query.results
    end
=end
end
