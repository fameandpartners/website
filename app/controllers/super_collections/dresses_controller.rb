class SuperCollections::DressesController < ApplicationController
  include Marketing::Gtm::Controller::Collection
  include ProductsHelper
  respond_to :html

  layout 'custom_experience/application'

  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  def index
    title('Custom Bridesmaid Dress Collection Page', default_seo_title)
    description('Fully customizable bridesmaid dresses, tailored to your wedding theme, colors, and each bridesmaids\' individual needs.')
  end

  def show
    @swatch_colors = fabric_swatch_colors.to_json
    title('Custom Bridesmaid Dress Collections', default_seo_title)
    description('Fully customizable bridesmaid dresses, tailored to your wedding theme, colors, and each bridesmaids\' individual needs.')

    @super_collection = {
      header: {
        img: "#{image_path('super_collections/header.jpg')}",
        img_tablet: "#{image_path('super_collections/header-tablet.jpg')}",
        img_mobile: "#{image_path('super_collections/header-mobile.jpg')}"
      },
      footer: {
        img: "#{image_path('super_collections/bottom.jpg')}",
        img_tablet: "#{image_path('super_collections/bottom-tablet.jpg')}",
        url: "/custom-dresses/find-your-bridesmaid-dress",
      },
      sections: [

        { type: 'shop_by', title: 'Theme', grid_class: 'grid-2_sm-1_xs-1',
          sections: [

          { name: "Bohemian",
            img: "#{image_path('super_collections/themes/bohemian.jpg')}",
            img_mobile: "#{image_path('super_collections/themes/bohemian-mobile.jpg')}",
            url: "/custom-dresses/bohemian-wedding-bridesmaid-dresses" },

          { name: "Rustic",
            img: "#{image_path('super_collections/themes/rustic.jpg')}",
            img_mobile: "#{image_path('super_collections/themes/rustic-mobile.jpg')}",
            url: "/custom-dresses/rustic-wedding-bridesmaid-dresses" },

          { name: "Garden Party",
            img: "#{image_path('super_collections/themes/garden-party.jpg')}",
            img_mobile: "#{image_path('super_collections/themes/garden-party-mobile.jpg')}",
            url: "/custom-dresses/garden-wedding-bridesmaid-dresses" },

          { name: "Resort",
            img: "#{image_path('super_collections/themes/resort.jpg')}",
            img_mobile: "#{image_path('super_collections/themes/resort-mobile.jpg')}",
            url: "/custom-dresses/resort-beach-wedding-bridesmaid-dresses" },

          { name: "Cocktail",
            img: "#{image_path('super_collections/themes/cocktail.jpg')}",
            img_mobile: "#{image_path('super_collections/themes/cocktail-mobile.jpg')}",
            url: "/custom-dresses/cocktail-wedding-bridesmaid-dresses" },

          { name: "Black Tie",
            img: "#{image_path('super_collections/themes/black-tie.jpg')}",
            img_mobile: "#{image_path('super_collections/themes/black-tie-mobile.jpg')}",
            url: "/custom-dresses/black-tie-wedding-bridesmaid-dresses" },

        ] },

        { type: 'shop_by', title: 'Silhouette', grid_class: 'grid-2_sm-1_xs-1',
          sections: [

          { name: "The Column",
            img: "#{image_path('super_collections/silhouettes/strapless-column.jpg')}",
            img_mobile: "#{image_path('super_collections/silhouettes/strapless-column-mobile.jpg')}",
            url: "/custom-dresses/slip-bridesmaid-dress" },

          { name: "The Jumpsuit",
            img: "#{image_path('super_collections/silhouettes/jumpsuit.jpg')}",
            img_mobile: "#{image_path('super_collections/silhouettes/jumpsuit-mobile.jpg')}",
            url: "/custom-dresses/jumpsuit-bridesmaid-dress" },

          { name: "The Slip",
            img: "#{image_path('super_collections/silhouettes/slip.jpg')}",
            img_mobile: "#{image_path('super_collections/silhouettes/slip-mobile.jpg')}",
            url: "/custom-dresses/slip-bridesmaid-dress" },

          { name: "The Fit and Flare",
            img: "#{image_path('super_collections/silhouettes/fit-flare.jpg')}",
            img_mobile: "#{image_path('super_collections/silhouettes/fit-flare-mobile.jpg')}",
            url: "/custom-dresses/fit-and-flare-bridesmaid-dress" },

          { name: "The Wrap",
            img: "#{image_path('super_collections/silhouettes/wrap.jpg')}",
            img_mobile: "#{image_path('super_collections/silhouettes/wrap-mobile.jpg')}",
            url: "/custom-dresses/wrap-bridesmaid-dress" },

          { name: "The Gown",
            img: "#{image_path('super_collections/silhouettes/gown.jpg')}",
            img_mobile: "#{image_path('super_collections/silhouettes/gown-mobile.jpg')}",
            url: "/custom-dresses/gown-bridesmaid-dress" },
        ] },

        { type: 'shop_by', title: 'Season', grid_class: 'grid-2_sm-1_xs-1',
          sections: [

          { name: "Spring",
            img: "#{image_path('super_collections/seasons/spring.jpg')}",
            img_mobile: "#{image_path('super_collections/seasons/spring-mobile.jpg')}",
            url: "/custom-dresses/spring-wedding-bridesmaid-dresses" },

          { name: "Summer",
            img: "#{image_path('super_collections/seasons/summer.jpg')}",
            img_mobile: "#{image_path('super_collections/seasons/summer-mobile.jpg')}",
            url: "/custom-dresses/summer-wedding-bridesmaid-dresses" },

          { name: "Fall",
            img: "#{image_path('super_collections/seasons/fall.jpg')}",
            img_mobile: "#{image_path('super_collections/seasons/fall-mobile.jpg')}",
            url: "/custom-dresses/fall-wedding-bridesmaid-dresses" },

          { name: "Winter",
            img: "#{image_path('super_collections/seasons/winter.jpg')}",
            img_mobile: "#{image_path('super_collections/seasons/winter-mobile.jpg')}",
            url: "/custom-dresses/winter-wedding-bridesmaid-dresses" },

        ] },

        { type: 'shop_by', title: 'Color', grid_class: 'grid-6_sm-3_xs-3',
          sections: [

          { name: "Pale Pink",
            img: "#{image_path('super_collections/swatches/pale-pink.jpg')}",
            url: "/custom-dresses/pale-pink-bridesmaid-dress" },

          { name: "Champagne",
            img: "#{image_path('super_collections/swatches/champagne.jpg')}",
            url: "/custom-dresses/champagne-bridesmaid-dress" },

          { name: "Blush",
            img: "#{image_path('super_collections/swatches/blush.jpg')}",
            url: "/custom-dresses/blush-pink-bridesmaid-dress" },

          { name: "Peach",
            img: "#{image_path('super_collections/swatches/peach.jpg')}",
            url: "/custom-dresses/peach-bridesmaid-dress" },

          { name: "Guava",
            img: "#{image_path('super_collections/swatches/guava.jpg')}",
            url: "/custom-dresses/guava-bridesmaid-dress" },

          { name: "Red",
            img: "#{image_path('super_collections/swatches/red.jpg')}",
            url: "/custom-dresses/red-bridesmaid-dress" },

          { name: "Burgundy",
            img: "#{image_path('super_collections/swatches/burgundy.jpg')}",
            url: "/custom-dresses/burgundy-bridesmaid-dress" },

          { name: "Berry",
            img: "#{image_path('super_collections/swatches/berry.jpg')}",
            url: "/custom-dresses/berry-bridesmaid-dress" },

          { name: "Lilac",
            img: "#{image_path('super_collections/swatches/lilac.jpg')}",
            url: "/custom-dresses/lilac-bridesmaid-dress" },

          { name: "Pale Blue",
            img: "#{image_path('super_collections/swatches/pale-blue.jpg')}",
            url: "/custom-dresses/pale-blue-bridesmaid-dress" },

          { name: "Royal Blue",
            img: "#{image_path('super_collections/swatches/royal-blue.jpg')}",
            url: "/custom-dresses/royal-blue-bridesmaid-dress" },

          { name: "Navy",
            img: "#{image_path('super_collections/swatches/navy.jpg')}",
            url: "/custom-dresses/navy-bridesmaid-dress" },

          { name: "Black",
            img: "#{image_path('super_collections/swatches/black.jpg')}",
            url: "/custom-dresses/black-bridesmaid-dress" },

          { name: "Pale Grey",
            img: "#{image_path('super_collections/swatches/pale-grey.jpg')}",
            url: "/custom-dresses/pale-grey-bridesmaid-dress" },

          { name: "Ivory",
            img: "#{image_path('super_collections/swatches/ivory.jpg')}",
            url: "/custom-dresses/ivory-bridesmaid-dress" },

          { name: "Mint",
            img: "#{image_path('super_collections/swatches/mint.jpg')}",
            url: "/custom-dresses/mint-bridesmaid-dress" },

          { name: "Bright Turquoise",
            img: "#{image_path('super_collections/swatches/bright-turquoise.jpg')}",
            url: "/custom-dresses/bright-turquoise-bridesmaid-dress" },

          { name: "Sage Green",
            img: "#{image_path('super_collections/swatches/sage-green.jpg')}",
            url: "/custom-dresses/sage-green-bridesmaid-dress" },
        ] }
      ]
    }
  end

  def theme
    @swatch_colors = fabric_swatch_colors.to_json
    @theme = Theme.find_by_name(params[:theme_name])
    if @theme
      @result = JSON.parse(@theme.collection)
    else
      render :status => 404
    end
  end

  private

  def image_path(image)
    ActionController::Base.helpers.image_path image
  end

  def redirect_site_version
    redirect_path = params.dig(:redirect, current_site_version.permalink.to_sym)
    if redirect_path.present?
      redirect_to url_fo/custom-dressesr(redirect_path)
    end
  rescue NoMethodError => e
    # :noop:
  end

  def redirect_undefined
    if params[:permalink] =~ /undefined\Z/
      redirect_to '/undefined', status: :moved_permanently
    end
  end


  def current_currency
    @current_currency ||= (site_version.try(:currency).to_s.upcase || 'USD')
  end

  def site_version
      @current_site_version ||= begin
        ::FindUsersSiteVersion.new(
            user:         current_spree_user,
            url_pa/custom-dressesram:    request.env['site_version_code'],
            cookie_param: session[:site_version]
        ).get
      end
  end


end
