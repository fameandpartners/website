# trying to rewrite old-not-good Products::BannerInfo
#   it was bad idea to pass whole searcher or collection here.
# just pass settings - get any from from Products::BannerInfo
#   style       - taxon from style taxonomy
#   event       - taxon from event taxonomy
#   bodyshape   - shape
#   color       - color
#   discount    - sale discount for products [ sale ]
#
class Products::CollectionBanner
  attr_reader :style, :event, :bodyshape, :color, :sale

  def initialize(options = {})
    @style      = options[:style]
    @event      = options[:event]
    @bodyshape  = options[:bodyshape]
    @color      = options[:color]
    @discount   = options[:discount]
  end

  def read
    taxon_banner = Spree::TaxonBanner.first
    OpenStruct.new(
      title: taxon_banner.title,
      description: taxon_banner.description
      #image: taxon_banner.image.present? ? taxon_banner.image.url : ''
    )
  end

  private
end
