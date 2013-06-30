Spree::ProductsController.class_eval do
  respond_to :html, :json
  before_filter :load_product, :only => [:show, :quick_view]

#  def index
#    @searcher = Config.searcher_class.new(params)
#    @searcher.current_user = try_spree_current_user
#    @searcher.current_currency = current_currency
#    @products = @searcher.retrieve_products
#    respond_with(@products)
#  end

  def index
    @searcher = Products::ProductsFilter.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products

    @colors = Products::ColorsSearcher.new(@products.to_a).retrieve_colors

    if !request.xhr?
      render action: 'index', layout: true
    else
      text = render_to_string(partial: 'products', locals: { products: @products, colors: @colors })
      render text: text, layout: false
    end
  end

  # NOTE: original method check case when user comes from page
  # with t= params and load corresponding taxon
  def show
    return unless @product

    @product_properties = @product.product_properties.includes(:property)

    @similar_products   = Spree::Product.limit(4)
    @product_variants  = get_product_variants(@product)

    respond_with(@product)
  end

  def quick_view
    #return unless request.xhr? && @product
    @product_variants  = get_product_variants(@product)

    respond_to do |format|
      format.html # default
      format.json do
        render json: { 
          popup_html: render_to_string(template: 'spree/products/quick_view.html.slim'),
          variants: get_product_variants(@product)
        }
      end
    end
  end

  private

  # returns [{ variant_id: 123, color: 'black', size: 12, fast_delivery: true} ]
  def get_product_variants(product)
    color_option  = Spree::OptionType.where(name: 'dress-color').first
    size_option   = Spree::OptionType.where(name: 'dress-size').first

    available_options = []
    product.variants.each do |variant|
      available_option = { id: variant.id }
      variant.option_values.each do |option_value|
        if option_value.option_type_id == color_option.id
          available_option[:color] = option_value.name
        elsif option_value.option_type_id == size_option.id
          available_option[:size] = option_value.name
        end
      end

      # if item in stock
      available_option[:fast_delivery] = variant.count_on_hand > 0

      available_options.push(available_option)
    end

    return available_options
  end
end
