# trying to rewrite old-not-good Products::BannerInfo
#   it was bad idea to pass whole searcher or collection here.
#
# just pass settings - get any from from Products::BannerInfo
#   collection  - taxon from range taxonomy
#   style       - taxon from style taxonomy
#   event       - taxon from event taxonomy
#   edits       - taxon from edits taxonomy
#   bodyshape   - shape
#   color       - color
#   discount    - sale discount for products [ sale ]
#
#   Details = {
#     title         - page title
#     description   - page meta description
#     footer        - page footer description
#     banner = {  # collection page top banner h1,h2,img
#       title, description, image
#     }
#   }
class Products::CollectionDetails
  # include Repositories::CachingSystem

  attr_reader :collection, :style, :event, :edits, :bodyshape, :color, :discount, :site_version, :root_taxon

  def initialize(options = {})
    @collection = options[:collection]
    @style      = options[:style]
    @event      = options[:event]
    @edits      = options[:edits]
    @bodyshape  = options[:bodyshape]
    @color      = options[:color]
    @discount   = options[:discount]
    @site_version = options[:site_version]
    @root_taxon ||= Repositories::Taxonomy.collection_root_taxon
  end

  def read
    taxon
  end

  # cache_results :read

  private

  def taxon
    @taxon ||= [edits, collection, style, event, root_taxon].compact.first
  end

  # def cache_key
  #   "collection-details-#{ site_version.permalink}-#{ taxon.permalink }"
  # end

end
