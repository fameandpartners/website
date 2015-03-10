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
  attr_reader :collection, :style, :event, :edits, :bodyshape, :color, :discount
  attr_reader :empty_collection

  def initialize(options = {})
    @collection = options[:collection]
    @style      = options[:style]
    @event      = options[:event]
    @edits      = options[:edits]
    @bodyshape  = options[:bodyshape]
    @color      = options[:color]
    @discount   = options[:discount]

    @empty_collection ||= Repositories::Taxonomy.collection_root_taxon
  end

  def read
    OpenStruct.new(
      title: title,
      description: description,
      footer: footer,
      banner: OpenStruct.new(
        title: banner_title,
        description: banner_description,
        image: banner_image
      )
    )
  end

  def templates
    {
      title: {
        sale_all:   "All Dresses on Sale",
        sale:       "Sale %{discount}%% Off",
        default:    "Shop the latest %{color} %{style} %{event} Dresses %{bodyshape}",
        bodyshape:  " for %{bodyshape} body shapes"
      },
      description: {
        sale_all:   "View all dresses on sale",
        sale:       "View all dresses with %{discount}%% off",
        default:    "Shop and customize the best %{color} %{style} %{event} dress trends %{event} at Fame & Partners."
      },
      banner_title: {
        #default:    "Fame & Partners Formal Dresses",
        sale_all:   "All Dresses on Sale",
        sale:       "Sale %{discount}%% Off",
        default:    "%{color} %{style} %{event} dresses"
      },
      banner_description: {
        sale_all:   'View all dresses on sale',
        sale:       "View all dresses with %{discount}%% off",
        default:    "High fashion dresses."
      }
    }
  end

  private

    def title
      @title ||= get_title
    end

    def description
      @description ||= get_description
    end

    def footer
      @footer ||= get_footer
    end

    def banner_title
      @banner_title ||= get_title
    end

    def banner_description
      @banner_description ||= get_banner_description
    end

    def banner_image
      @banner_image ||= get_banner_image
    end

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
      taxons = [edits, collection, style, event].compact

      # add root collection taxon, for no-data case
      if color.blank? && bodyshape.blank?
        taxons.push(empty_collection)
      end

      taxons
    end

    def parent_taxon
      @parent_taxon ||= collection_taxons.first
    end

    # Page heading
    # briefly:
    #   - if sale collection, then title for sale [all or 10%]
    #   - if parent_taxon present?
    #     - try to extract from it
    #   - generate title based on params
    def get_title
      if discount.present?
        if discount.to_s == 'all'
          return templates[:title][:sale_all]
        else
          return (templates[:title][:sale] % { discount: discount.to_i })
        end
      end

      custom_title = parent_taxon.try(:banner).try(:title)
      custom_title ||= parent_taxon.try(:meta_title)
      return custom_title if custom_title.present?

      # if no specific titles, then compile from existing
      default_title = templates[:title][:default] % {
        color: is_formal_dress_color?(color) ? color.name.titleize : nil,
        style: style.present? ? style.name.titleize : '',
        event: event.present? ? event.name.titleize : '',
        bodyshape: bodyshape.blank? ? '' : ( templates[:title][:bodyshape] % { bodyshape: bodyshape } )
      }

      default_title.gsub!(/\s{1,}/, ' ').capitalize # remove double spaces
    end

    # Page meta description
    # briefly:
    #   - if sales, then sale [all or 10%]
    #   - if parent taxon - get data from it
    #   - generate title based on params
    #
    # NOTE: we don't use bodyshape here
    def get_description
      if discount.present?
        if discount.to_s == 'all'
          return templates[:description][:sale_all]
        else
          return (templates[:description][:sale] % { discount: discount.to_i })
        end
      end

      custom_description = parent_taxon.try(:banner).try(:seo_description)
      custom_description ||= parent_taxon.try(:meta_description)
      return custom_description if custom_description.present?

      # if no specific titles, then compile from existing
      default_description = templates[:description][:default] % {
        color: is_formal_dress_color?(color) ? color.name.titleize : nil,
        style: style.present? ? style.name.titleize : '',
        event: event.present? ? event.name.titleize : ''
      }

      default_description.gsub!(/\s{1,}/, ' ').capitalize # remove double spaces
    end

    def get_footer
      return nil if discount.present?
      footer_text = parent_taxon.try(:banner).try(:footer_text)

      nil
    end

    def get_banner_description
      if discount.present?
        if discount.to_s == 'all'
          return templates[:banner_description][:sale_all]
        else
          return (templates[:banner_description][:sale] % { discount: discount.to_i })
        end
      end

      text = parent_taxon.try(:banner).try(:description)
      text ||= parent_taxon.try(:description)
      return text if text.present?

      if is_formal_dress_color?(color)
        I18n.t(:subtitle, scope: [:collection, :colors, color.name.to_s.parameterize.underscore])
      else
        templates[:banner_description][:default]
      end
    end

    def get_banner_image
      return nil if discount.present?

      return nil if is_formal_dress_color?(color)

      image = parent_taxon.try(:banner).try(:image)
      return image if image

      nil
    end
end
