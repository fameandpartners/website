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

  attr_reader :collection, :style, :styles, :event, :edits, :bodyshape, :color,
              :discount, :site_version, :fast_delivery, :root_taxon, :fast_making

  def initialize(options = {})
    @collection     = options[:collection]
    @styles         = Array.wrap(options[:style])
    @style          = @styles.first
    @event          = options[:event]
    @edits          = options[:edits]
    @bodyshape      = options[:bodyshape]
    @color          = options[:color].first if options[:color].is_a?(Array)
    @discount       = options[:discount]
    @site_version   = options[:site_version]
    @fast_delivery  = options[:fast_delivery]
    @fast_making    = options[:fast_making]
    @root_taxon     ||= Repositories::Taxonomy.collection_root_taxon
  end

  def read
    fast_making_taxon if fast_making.present?
    colorize_taxon if color.present?
    deliverize_taxon if fast_delivery.present?

    taxon
  end

  private

  def taxon
    @taxon ||= [edits, collection, style, event, root_taxon].compact.first
  end

  # NOTICE!!!
  # Banner meta information is now handled by the Revolution CMS!!!
  # `#colorize_taxon`, `#deliverize_taxon`, `#fast_making_taxon`, `#color_data` meta information are obsolete!
  # The only thing this details `Product::CollectionDetails` class is still providing is banner images
  # => revolution CMS accepts collections resources: https://github.com/fameandpartners/website/blob/d94a69b40caae7f54f416e8b7658673c48b9585d/engines/revolution/app/models/revolution/page.rb#L30-L30
  # => banner images on Revolution Page: https://github.com/fameandpartners/website/blob/d94a69b40caae7f54f416e8b7658673c48b9585d/engines/revolution/app/models/revolution/page.rb#L51-L53
  def colorize_taxon
    taxon.meta_title        = "Shop the latest #{color[:presentation]} dresses"
    taxon.title             = "Shop and customize the best #{color[:presentation]} dress trends at Fame and Partners"
    taxon.description       = ''
    taxon.footer            = ''
    selected_color_data      = color_data[color[:name].to_s.downcase]
    if selected_color_data
      taxon.meta_title        = selected_color_data[:meta_title]
      taxon.seo_description   = selected_color_data[:meta_description]
      taxon.banner.title      = selected_color_data[:banner][:title]
      taxon.banner.subtitle   = selected_color_data[:banner][:subtitle]
      taxon.banner.image      = selected_color_data[:banner][:image]
    end
  end


  def deliverize_taxon
    taxon.meta_title        = "Shop the latest express delivery dresses"
    taxon.title             = "Shop and customize express delivery dresses at Fame and Partners"
    taxon.description       = ''
    taxon.footer            = ''
    taxon.banner.title      = 'Express Delivery Dresses'
    taxon.banner.subtitle   = 'High-fashion styles for fast-paced social butterflies.'
  end

  def fast_making_taxon
    taxon.meta_title        = "Shop the latest express delivery dresses"
    taxon.title             = "Shop and customize express delivery dresses at Fame and Partners"
    taxon.description       = ''
    taxon.footer            = ''
    taxon.banner.title      = 'GET IT QUICK!'
    taxon.banner.subtitle   = 'Introducing express making: Dresses made for you in 48 hours'
    taxon.banner.image      = "#{configatron.asset_host}/category-banners/express-making-dark-bg.jpg"
  end

  # NOTICE!!!
  # Banner meta information is now handled by the Revolution CMS!!!
  def color_data
    {
      'black'       => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/black-dresses-dark-bg.jpg"
        },
      },
      'blue-purple' => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/blue-dresses-bg.jpg"
        },
      },
      'green'       => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/green-dresses-bg.jpg"
        }
      },
      'grey'        => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/grey-dresses-bg.jpg"
        }
      },
      'nude-tan'    => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/nude-tan-dresses-bg.jpg"
        }
      },
      'pastel'      => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/pastel-dresses-bg.jpg"
        },
      },
      'pink'        => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/pink-dresses-bg.jpg"
        },
      },
      'red'         => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/red-dresses-dark-bg.jpg"
        },
      },
      'white-ivory' => {
        banner: {
          image: "#{configatron.asset_host}/category-banners/white-dresses-bg.jpg"
        },
      },
    }
  end
end
