Spree::ProductsController.class_eval do
  respond_to :html, :json
  before_filter :load_product, :only => [:show, :quick_view, :send_to_friend]
  after_filter :log_product_viewed

  def index
    @searcher = Products::ProductsFilter.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products

    set_collection_title(@searcher)

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

    @similar_products = Products::SimilarProducts.new(@product).fetch(4)
    @product_variants = Products::VariantsReceiver.new(@product).available_options

    @activities = load_product_activities(@product)

    respond_with(@product)
  end

  def quick_view
    @product_variants = Products::VariantsReceiver.new(@product).available_options

    popup_html = render_to_string(template: 'spree/products/quick_view.html.slim', product: @product, layout: false)

    @activities = load_product_activities(@product)

    render json: { 
      popup_html: popup_html,
      variants: @product_variants,
      analytics_label: analytics_label(:product, @product),
      activities: activites
    }
  end

  def send_to_friend
    user_info = params.extract!(:sender_name, :sender_email, :name, :email, :message)
    if spree_user_signed_in?
      user_info.update(
        sender_name: spree_current_user.fullname,
        sender_email: spree_current_user.email
      )
    end

    Spree::ProductMailer.send_to_friend(@product, user_info).deliver

    render json: { success_message: 'successfully sended' }
  end

  private

  def set_collection_title(searcher)
    taxon_ids = searcher.collection || []
    taxons = Spree::Taxon.where(id: taxon_ids)

    # generate custom meta for paths like 'Black-Dresses', 'Red-Dresses' & etc
    if searcher.colour && searcher.colour.length == 1
      colour_name = searcher.colour.first.name
      collection_title ="#{colour_name.capitalize} Dresses, #{colour_name.capitalize} Evening Dresses Online, Prom and Formals - Fame & Partners"
      collection_description = "Fame & Partners stock a wide range of #{colour_name} dresses online for all occasions, visit our store today."
    # if only one taxon selected, use its meta or name
    elsif taxon_ids.present? && taxons.count == 1 && (taxon = taxons.first)
      collection_title = taxon.meta_title || [taxon.name, default_seo_title].join(' - ')
      collection_description = taxon.meta_description || [taxon.name, default_meta_description].join(' - ')
    else
      collection_title = ['Our Dress Collection', default_seo_title].join(' - ')
      collection_description = ['Our Dress Collection', default_meta_description].join(' - ')
    end

    self.title = collection_title
    description(collection_description)
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

  def log_product_viewed
    return unless @product
    Activity.log_product_viewed(@product, temporary_user_key, try_spree_current_user)
  end

  def load_product_activities(owner)
    scope = Activity.where(owner_type: owner.class.to_s, owner_id: owner.id)
    scope = scope.where("updated_at > ?", 5.days.ago).order('updated_at desc')
    scope.limit(10)
  end
end
