class SuperCollections::DressesController < ApplicationController
  include Marketing::Gtm::Controller::Collection
  include ProductsHelper
  respond_to :html

  layout 'custom_experience/application'

  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  def show

    title('Custom Bridesmaid Dress Collections', default_seo_title)
    description('Fully customizable bridesmaid dresses, tailored to your wedding theme, colors, and each bridesmaids\' individual needs.')

    @super_collection = {
      header: {
        img: "http://fakeimg.pl/1439x592/?text=hero"
      },
      footer: {
        img: "http://fakeimg.pl/1439x592/?text=footer"
      },
      sections: [

        { type: 'shop_by', title: 'Theme', grid_class: 'grid-2_sm-1_xs-1',
          sections: [

          { name: "Rustic",
            img: "http://fakeimg.pl/635x717/?text=rustic",
            url: "/rustic-wedding-bridesmaid-dresses" },

          { name: "Garden",
            img: "http://fakeimg.pl/635x717/?text=garden",
            url: "/garden-wedding-bridesmaid-dresses" },

          { name: "Black Tie",
            img: "http://fakeimg.pl/635x717/?text=black+tie",
            url: "/black-tie-wedding-bridesmaid-dresses" },

          { name: "Cocktail",
            img: "http://fakeimg.pl/635x717/?text=cocktail",
            url: "/cocktail-wedding-bridesmaid-dresses" },

          { name: "Resort",
            img: "http://fakeimg.pl/635x717/?text=resort",
            url: "/resort-beach-wedding-bridesmaid-dresses" },

          { name: "Bohemian",
            img: "http://fakeimg.pl/635x717/?text=bohemian",
            url: "/bohemian-wedding-bridesmaid-dresses" },
        ] },

        { type: 'shop_by', title: 'Silhouette', grid_class: 'grid-2_sm-1_xs-1',
          sections: [

          { name: "The Strapless Column",
            img: "#{image_path('super_collections/silhouettes/strapless-column.jpg')}",
            url: "/slip-bridesmaid-dress" },

          { name: "The Jumpsuit",
            img: "#{image_path('super_collections/silhouettes/jumpsuit.jpg')}",
            url: "/jumpsuit-bridesmaid-dress" },

          { name: "The Slip",
            img: "#{image_path('super_collections/silhouettes/slip.jpg')}",
            url: "/slip-bridesmaid-dress" },

          { name: "The Fit and Flare",
            img: "#{image_path('super_collections/silhouettes/fit-flare.jpg')}",
            url: "/fit-and-flare-bridesmaid-dress" },

          { name: "The Wrap",
            img: "#{image_path('super_collections/silhouettes/wrap.jpg')}",
            url: "/wrap-bridesmaid-dress" },

          { name: "The Gown",
            img: "#{image_path('super_collections/silhouettes/gown.jpg')}",
            url: "/gown-bridesmaid-dress" },
        ] },

        { type: 'shop_by', title: 'Season', grid_class: 'grid-2_sm-1_xs-1',
          sections: [

          { name: "Summer",
            img: "http://fakeimg.pl/635x717/?text=summer",
            url: "/summer-wedding-bridesmaid-dresses" },

          { name: "Winter",
            img: "http://fakeimg.pl/635x717/?text=winter",
            url: "/winter-wedding-bridesmaid-dresses" },

          { name: "Spring",
            img: "http://fakeimg.pl/635x717/?text=spring",
            url: "/spring-wedding-bridesmaid-dresses" },

          { name: "Fall",
            img: "http://fakeimg.pl/635x717/?text=fall",
            url: "/fall-wedding-bridesmaid-dresses" },
        ] },

        { type: 'shop_by', title: 'Color', grid_class: 'grid-6_sm-3_xs-3',
          sections: [

          { name: "Pale Pink",
            img: "#{image_path('super_collections/swatches/pale-pink.jpg')}",
            url: "/pale-pink-bridesmaid-dress" },

          { name: "Champagne",
            img: "#{image_path('super_collections/swatches/champagne.jpg')}",
            url: "/champagne-bridesmaid-dress" },

          { name: "Blush",
            img: "#{image_path('super_collections/swatches/blush.jpg')}",
            url: "/blush-pink-bridesmaid-dress" },

          { name: "Peach",
            img: "#{image_path('super_collections/swatches/peach.jpg')}",
            url: "/peach-bridesmaid-dress" },

          { name: "Guava",
            img: "#{image_path('super_collections/swatches/guava.jpg')}",
            url: "/guava-bridesmaid-dress" },

          { name: "Red",
            img: "#{image_path('super_collections/swatches/red.jpg')}",
            url: "/red-bridesmaid-dress" },

          { name: "Burgundy",
            img: "#{image_path('super_collections/swatches/burgundy.jpg')}",
            url: "/burgundy-bridesmaid-dress" },

          { name: "Berry",
            img: "#{image_path('super_collections/swatches/berry.jpg')}",
            url: "/berry-bridesmaid-dress" },

          { name: "Lilac",
            img: "#{image_path('super_collections/swatches/lilac.jpg')}",
            url: "/lilac-bridesmaid-dress" },

          { name: "Pale Blue",
            img: "#{image_path('super_collections/swatches/pale-blue.jpg')}",
            url: "/pale-blue-bridesmaid-dress" },

          { name: "Royal Blue",
            img: "#{image_path('super_collections/swatches/royal-blue.jpg')}",
            url: "/royal-blue-bridesmaid-dress" },

          { name: "Navy",
            img: "#{image_path('super_collections/swatches/navy.jpg')}",
            url: "/navy-bridesmaid-dress" },

          { name: "Black",
            img: "#{image_path('super_collections/swatches/black.jpg')}",
            url: "/black-bridesmaid-dress" },

          { name: "Pale Grey",
            img: "#{image_path('super_collections/swatches/pale-grey.jpg')}",
            url: "/pale-grey-bridesmaid-dress" },

          { name: "Ivory",
            img: "#{image_path('super_collections/swatches/ivory.jpg')}",
            url: "/ivory-bridesmaid-dress" },

          { name: "Mint",
            img: "#{image_path('super_collections/swatches/mint.jpg')}",
            url: "/mint-bridesmaid-dress" },

          { name: "Bright Turquoise",
            img: "#{image_path('super_collections/swatches/bright-turquoise.jpg')}",
            url: "/bright-turquoise-bridesmaid-dress" },

          { name: "Sage Green",
            img: "#{image_path('super_collections/swatches/sage-green.jpg')}",
            url: "/sage-green-bridesmaid-dress" },
        ] }
      ]
    }
  end

  private

  def image_path(image)
    ActionController::Base.helpers.image_path image
  end

  def redirect_site_version
    redirect_path = params.dig(:redirect, current_site_version.permalink.to_sym)
    if redirect_path.present?
      redirect_to url_for(redirect_path)
    end
  rescue NoMethodError => e
    # :noop:
  end

  def redirect_undefined
    if params[:permalink] =~ /undefined\Z/
      redirect_to '/undefined', status: :moved_permanently
    end
  end
end
