class Products::CategoriesController < Products::BaseController
  layout 'redesign/application'

  def show
    category = Products::CategoryResource.new(
      site_version: current_site_version,
      limit: 8
    ).read

    @products = category.products
    @banner   = category.banner
    @filter   = filter
  end

  private

    def filter
      OpenStruct.new({
        styles: Repositories::Taxonomy.read_styles,
        events: Repositories::Taxonomy.read_events,
        shapes: ProductStyleProfile::BODY_SHAPES,
        colors: Spree::Variant.color_option_type.try(:option_values) || [],
        sort_orders: available_sort_orders
      })
    end

    # copy-paste from Spree::Variant.color_option_type.try(:option_values) 
    # Products::ProductsFilter.available_sort_orders,
    def available_sort_orders
      [
        ['price_high', 'Price High'],
        ['price_low', 'Price Low'],
        ['newest', "What's new"],
        ['fast_delivery', 'Next day delivery']
      ]
    end
end
