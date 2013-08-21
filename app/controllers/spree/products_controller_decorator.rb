Spree::ProductsController.class_eval do
  respond_to :html, :json
  before_filter :load_product, :only => [:show, :quick_view, :send_to_friend]

  def index
    @searcher = Products::ProductsFilter.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products

    set_collection_title(@searcher.collection)

    if !request.xhr?
      render action: 'index', layout: true
    else
      text = render_to_string(partial: 'products', locals: { products: @products })
      render text: text, layout: false
    end
  end

  # NOTE: original method check case when user comes from page
  # with t= params and load corresponding taxon
  def show
    return unless @product

    set_product_show_page_title(@product)
    @product_properties = @product.product_properties.includes(:property)

    @similar_products   = Products::SimilarProducts.new(@product).fetch(4)
    @product_variants = Products::VariantsReceiver.new(@product).available_options

    respond_with(@product)
  end

  def quick_view
    #return unless request.xhr? && @product
    @product_variants = Products::VariantsReceiver.new(@product).available_options

    popup_html = render_to_string(template: 'spree/products/quick_view.html.slim', product: @product, layout: false)
    render json: { 
      popup_html: popup_html,
      variants: @product_variants,
      analytics_label: analytics_label(:product, @product)
    }
  end

  def send_to_friend
    user_info = params.extract!(:sender_name, :sender_email, :name, :email, :message)
    Spree::ProductMailer.send_to_friend(try_spree_current_user, @product, user_info).deliver

    render json: { success_message: 'successfully sended' }
  end

  private

  def set_collection_title(taxon_ids = [])
    taxons = Spree::Taxon.where(id: taxon_ids)
    if taxon_ids.blank? || taxons.blank? || taxons.count > 1
      prefix = "Our Dress Collection"
    else
      prefix = taxons.first.name
    end

    self.title = [prefix, default_seo_title].join(' - ')
    description([prefix, default_meta_description].join(' - '))
  end

  def set_product_show_page_title(product)
    range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first

    if range_taxonomy.present? && range_taxon = @product.taxons.where(taxonomy_id: range_taxonomy.id).first
      prefix = "#{@product.name} in #{range_taxon.name}"
      self.title = [prefix, default_seo_title].join(' - ')
      description([prefix, default_meta_description].join(' - '))
    end
  end

  def colors
    @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
  end

  helper_method :colors
end
