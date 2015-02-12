# trying to rewrite old-not-good Products::BannerInfo
#   it was bad idea to pass whole searcher or collection here.
# just pass settings - get any from from Products::BannerInfo
#   collection  - taxon from range taxonomy
#   style       - taxon from style taxonomy
#   event       - taxon from event taxonomy
#   edits       - taxon from edits taxonomy
#   bodyshape   - shape
#   color       - color
#   discount    - sale discount for products [ sale ]
#
class Products::CollectionBanner
  attr_reader :collection, :style, :event, :edits, :bodyshape, :color, :discount

  def initialize(options = {})
    @collection = options[:collection]
    @style      = options[:style]
    @event      = options[:event]
    @edits      = options[:edits]
    @bodyshape  = options[:bodyshape]
    @color      = options[:color]
    @discount   = options[:discount]
  end

  def read
    OpenStruct.new(
      title: title,
      description: 'in work',
      image: ''
    )
  end

  def templates
    {
      title: {
        sale_all:   "All Dresses on Sale | Fame & Partners",
        sale:       "Sale %{ discount }% Off | Fame & Partners",
        default:    "Shop the latest %{color} %{style} %{event} Dresses %{bodyshape} | Fame & Partners",
        bodyshape:  " for %{bodyshape} body shapes"
      }
    }
  end

  private

    # formal color or not.
    # possible, this is color property
    def available_formal_dresses_colors
      colors = %w{black blue blush champagne coral gold green neon pastel peach pink red teal turquoise}
      colors + ['light blue', 'black and white']
    end

    def is_formal_dress_color?(color)
      return false if color.blank?
      available_formal_dresses_colors.include?(color.name)
    end

    # define 'root' taxon for collection
    def collection_taxons
      # manage order to set priority
      taxons = [collection, edits, style, event].compact

      # if no data, then plain collection
      return [collection_root_taxon] if taxons.blank? && color.blank? && bodyshape.blank?
    end

    def collection_root_taxon
      @collection_root_taxon ||= Repositories::Taxonomy.collection_root_taxon
    end

    # briefly:
    #   - if sales, then sale [all or 10%]
    #   - if collection have taxons
    #     - trying to extract title from banner
    #     - trying to extract title directly
    #   - if collection have no taxons & colors & anything
    #     - trying to use root collection taxon [ title / banner ]
    #   - generate title based on params
    def title
      if discount.present?
        if discount.to_sym == :all
          return templates[:title][:sale_all]
        else
          return (templates[:title][:sale] % discount.to_i)
        end
      end

      # trying to extract custom title from 
      #   collection, event, edit, style taxon, or collection_base
      if collection_taxons.present?
        taxon = collection_taxons.find{|t| t.banner.present? && t.banner.title.present? }
        return taxon.banner.title if taxon.present?

        taxon  = collection_taxons.find{|t| t.meta_title.present? }
        return taxon.meta_title if taxon.present?
      end

      # if no specific titles, then compile from existing
      default_title = templates[:title][:default] % {
        color: is_formal_dress_color?(color) ? color.name.titleize : nil,
        style: style.present? ? style.name.titleize : '',
        event: event.present? ? event.name.titleize : 'Any Event',
        bodyshape: bodyshape.blank? ? '' : ( templates[:title][:bodyshape] % bodyshape )
      }

      default_title.gsub!(/\s{1,}/, ' ').capitalize # remove double spaces
    end
end
