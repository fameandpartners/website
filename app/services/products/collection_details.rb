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

  attr_reader :collection, :style, :event, :edits, :bodyshape, :color, :discount, :site_version, :fast_delivery, :root_taxon

  def initialize(options = {})
    @collection     = options[:collection]
    @style          = options[:style]
    @event          = options[:event]
    @edits          = options[:edits]
    @bodyshape      = options[:bodyshape]
    @color          = options[:color]
    @discount       = options[:discount]
    @site_version   = options[:site_version]
    @fast_delivery  = options[:fast_delivery]
    @root_taxon     ||= Repositories::Taxonomy.collection_root_taxon
  end

  def read
    colorize_taxon if color.present?
    deliverize_taxon if fast_delivery?
    taxon
  end

  # cache_results :read

  private

  def taxon
    @taxon ||= [edits, collection, style, event, root_taxon].compact.first
  end

  def colorize_taxon
    taxon.meta_title        = "Shop the latest #{color.presentation} dresses"
    taxon.title             = "Shop and customize the best #{color.presentation} dress trends at Fame & Partners"
    taxon.description       = ''
    taxon.footer            = ''
    selected_color_data      = color_data[color.name.to_s.downcase]
    if selected_color_data
      taxon.banner.title      = selected_color_data[:title]
      taxon.banner.subtitle   = selected_color_data[:description]
      taxon.banner.image      = selected_color_data[:image]
    end
  end


  def deliverize_taxon
    taxon.meta_title        = "Shop the latest express delivery dresses"
    taxon.title             = "Shop and customize express delivery dresses at Fame & Partners"
    taxon.description       = ''
    taxon.footer            = ''
    taxon.banner.title      = 'Express Delivery Dresses'
    taxon.banner.subtitle   = 'High-fashion styles for fast-paced social butterflies.'
  end

  def color_data
    {
      "black" => {
        :title        => "Black Dresses",
        :description  => "There's nothing basic about these chic black dresses.",
        :image        => "/assets/category-banners/black-dresses-dark-bg.jpg"
      },
      "white" => {
        :title        => "White and Ivory Dresses",
        :description  => "Refresh your look with a pristine clean slate.",
        :image        => "/assets/category-banners/white-dresses-bg.jpg"
      },
      "blue" => {
        :title        => "Blue Dresses",
        :description  => "Get the blues (in a good way) with sky-shaded styles.",
        :image        => "/assets/category-banners/blue-dresses-bg.jpg"
      },
      "pink" => {
        :title        => "Pink Dresses",
        :description  => "From girly to glam, these pink confections satisfy any sweet tooth.",
        :image        => "/assets/category-banners/pink-dresses-bg.jpg"
      },
      "red" => {
        :title        => "Red Dresses",
        :description  => "Look red haute in statement-making shades.",
        :image        => "/assets/category-banners/red-dresses-dark-bg.jpg"
      },
      "pastel" => {
        :title        => "Pastel Dresses",
        :description  => "Treat yourself to sweet styles in the prettiest shades of pale.",
        :image        => "/assets/category-banners/pastel-dresses-bg.jpg"
      },
    }
  end

  def fast_delivery?
    fast_delivery == true
  end

end
