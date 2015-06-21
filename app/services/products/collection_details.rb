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

  attr_reader :collection, :style, :event, :edits, :bodyshape, :color, :discount, :site_version, :fast_delivery, :root_taxon, :fast_making

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
    @fast_making    = options[:fast_making]
    @root_taxon     ||= Repositories::Taxonomy.collection_root_taxon
  end

  def read
    fast_making_taxon if fast_making.present?
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
      taxon.meta_title        = selected_color_data[:meta_title]
      taxon.seo_description   = selected_color_data[:meta_description]
      taxon.banner.title      = selected_color_data[:banner][:title]
      taxon.banner.subtitle   = selected_color_data[:banner][:subtitle]
      taxon.banner.image      = selected_color_data[:banner][:image]
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

  def fast_making_taxon
    taxon.meta_title        = "Shop the latest express delivery dresses"
    taxon.title             = "Shop and customize express delivery dresses at Fame & Partners"
    taxon.description       = ''
    taxon.footer            = ''
    taxon.banner.title      = 'GET IT QUICK!'
    taxon.banner.subtitle   = 'Introducing express making: Dresses made for you in 48 hours'
    taxon.banner.image      = '/assets/category-banners/express-making-dark-bg.jpg'
  end

  def color_data
    {
      "black" => {
        :banner => {
          :title => 'Black Dresses',
          :subtitle => 'The black dress has taken a new turn. A timeless item in your wardrobe perfect for every occasion. Any style, we’ve got you covered.',
          :image => "/assets/category-banners/black-dresses-dark-bg.jpg"
        },
        :meta_title        => 'Black dresses and gowns',
        :meta_description  => "Find a black dress for any occasion and style from prom to maxi’s. Transform and customize your look from day-time office to night-time chic.",
      },
      "white" => {
        :banner => {
          :title => 'White/ivory Dresses',
          :subtitle => 'Clean cuts and pristine whites make for a refreshing look. Achieve effortless style in sleek white dresses, with a modern twist.',
          :image => "/assets/category-banners/white-dresses-bg.jpg"
        },
        :meta_title        => 'White dresses online',
        :meta_description  => "Made to order white dresses. Perfect for every occasion .Whether a bride or a fashion diva, white is a class and a wardrobe must.",
      },
      "blue" => {
        :banner => {
          :title => 'Blue Dresses',
          :subtitle => 'Feeling blue? Change it up in bold & daring shades of teal, turquoise or navy dresses and add an unexpected turn to your wardrobe.',
          :image => "/assets/category-banners/blue-dresses-bg.jpg"
        },
        :meta_title        => 'Blue dresses | Shop our trending range',
        :meta_description  => "Fame & Partners offers a wide variety of blue dresses. From Icy to baby blue, we have it all.",
      },
      "pink" => {
        :banner => {
          :title => 'Pink Dresses',
          :subtitle => 'Candy and lolly pops? Only pink frocks! meh! Only pink dresses. Whether you’re tuning into your feminine or fierce side, pink will deliver.',
          :image => "/assets/category-banners/pink-dresses-bg.jpg"
        },
        :meta_title        => 'Pink dresses',
        :meta_description  => "Embrace girl power in every shade of pink. We’ve got you covered girl. Customise these killer dresses into the style you always wished for!",
      },
      "red" => {
        :banner => {
          :title => 'Red Dresses',
          :subtitle => 'Look red haute in statement-making shades.',
          :image => "/assets/category-banners/red-dresses-dark-bg.jpg"
        },
        :meta_title        => 'Red Dresses',
        :meta_description  => "Look red haute in statement-making shades.",
      },
      "pastel" => {
        :banner => {
          :title => 'Pastel Dresses',
          :subtitle => 'Indulge in sweet treats, in the prettiest way possible. A Pastel dress will take you from girly to glam and across all seasons in a click of a button.',
          :image => "/assets/category-banners/pastel-dresses-bg.jpg"
        },
        :meta_title        => 'Beautiful pastel dresses',
        :meta_description  => "Change it up in pastel hues and take on a fresh look inspired straight from the latest runway trends. Find your own dress style & add  these treats to your wardrobe.",
      },
    }
  end

  def fast_delivery?
    fast_delivery == true
  end

end
