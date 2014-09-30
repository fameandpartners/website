Spree::ProductsController.class_eval do
  include ApplicationHelper
  respond_to :html, :json
  before_filter :load_product, :only => [:show, :quick_view, :send_to_friend]
  before_filter :load_activities, :only => [:show, :quick_view]

  after_filter :log_product_viewed

  #caches_action :show,
  #              layout: false,
  #              expires_in: configatron.cache.expire.long,
  #              cache_path: proc{ |c| c.request.url + '.' + c.request.format.ref.to_s }

  def index

    currency = current_currency
    user = try_spree_current_user

    display_featured_dresses = params[:dfd]
    display_featured_dresses_edit = params[:dfde]

    @searcher = Products::ProductsFilter.new(params)
    @searcher.current_user = user
    @searcher.current_currency = currency

    @products         = @searcher.products
    @similar_products = @searcher.similar_products

    @page_info = @searcher.selected_products_info

    @current_colors = @searcher.colour.present? ? @searcher.colors_with_similar : []

    if (!display_featured_dresses.blank? && display_featured_dresses == "1") && !display_featured_dresses_edit.blank?
      @lp_featured_products = get_products_from_edit(display_featured_dresses_edit, currency, user, 4)
    end

    respond_to do |format|
      format.html do
        set_collection_title(@page_info)
        set_marketing_pixels(@searcher)

        render action: 'index', layout: true
      end
      format.json do
        products_html = render_to_string(
          partial: 'spree/products/products',
          formats: [:html]
        )
        render json: { products_html: products_html, page_info:  @page_info }
      end
    end 
  end

  # NOTE: original method check case when user comes from page
  # with t= params and load corresponding taxon
  def show
    return unless @product

    set_product_show_page_title(@product)
    display_marketing_banner

    @product_properties = @product.product_properties.includes(:property)

    @product_variants = Products::VariantsReceiver.new(@product).available_options
    @recommended_products = get_recommended_products(@product, limit: 3)

    respond_with(@product)
  end

  def quick_view
    @product_variants = Products::VariantsReceiver.new(@product).available_options

    popup_html = render_to_string(template: 'spree/products/quick_view.html.slim', product: @product, layout: false)

    render json: {
      popup_html: popup_html,
      variants: @product_variants,
      analytics_label: analytics_label(:product, @product),
      activities: @activites,
      images: @product.images_json,
      videos: @product.videos_json,
      default_video_url: @product.video_url
    }
  end

  def send_to_friend
    user_info = params.extract!(:sender_email, :email)
    if spree_user_signed_in?
      user_info.update(
        sender_email: spree_current_user.email,
        sender_name: spree_current_user.fullname
      )
    end

    Spree::ProductMailer.send_to_friend(@product, user_info, current_site_version).deliver

    render json: { success_message: 'successfully sended' }
  end

  def product_filtering
    
  end

  private

  def load_product
    if try_spree_current_user.try(:has_spree_role?, "admin")
      if params[:product_slug]
        @product = Spree::Product.find(get_id_from_slug(params[:product_slug]))
      else
        @product = Spree::Product.find_by_permalink!(params[:id])
      end
    else
      if params[:product_slug]
        @product = Spree::Product.active.find(get_id_from_slug(params[:product_slug]))
      else
        #@product = Product.active(current_currency).find_by_permalink!(params[:id])
        @product = Spree::Product.active.find_by_permalink!(params[:id])
      end
    end
  end

  # gets the product id from the slug that is fomatted as "somethin-something-something-.....-product_id"
  def get_id_from_slug(slug)
    slug.match(/(\d)+$/)[0]
  end

  def set_collection_title(info = {})
    unless info[:page_title].blank?
      self.title = info[:page_title] + " " + default_seo_title
      description(info[:meta_description] + " " + default_meta_description)
    else
      self.title = @page_info[:banner_title] + " - " + default_seo_title
      description = ActionController::Base.helpers.strip_tags(@page_info[:banner_text]) + ". " + default_meta_description
    end
  end

  def set_marketing_pixels(searcher)
    taxons = Spree::Taxon.where(id: searcher.collection || [])

    @marketing_pixels = ''

    return if taxons.empty?

    taxon_names = taxons.map(&:name).map(&:downcase).uniq

    if taxon_names.include?('long dresses')
      @marketing_pixels += '<img src="http://tags.rtbidder.net/track?sid=525646058bc06f1060d9edfa" width="0" height="0" border="0" alt="" />'
    end

    if taxon_names.include?('short dresses')
      @marketing_pixels += '<img src="http://tags.rtbidder.net/track?sid=525646288bc06f1060d9eed9" width="0" height="0" border="0" alt="" />'
    end

    if taxon_names.include?('skirts')
      @marketing_pixels += '<img src="http://tags.rtbidder.net/track?sid=5256465f8bc06f1060d9f036" width="0" height="0" border="0" alt="" />'
    end

    if taxon_names.include?('tops')
      @marketing_pixels += '<img src="http://tags.rtbidder.net/track?sid=5256468c8bc06f1060d9f0bf" width="0" height="0" border="0" alt="" />'
    end
  end

  def colors
    @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
  end

  helper_method :colors

  def featured_products
    @featured_products ||= Spree::Product.active.featured.uniq.includes(:master)
  end

  helper_method :featured_products

  def log_product_viewed
    return unless @product
    Activity.log_product_viewed(@product, temporary_user_key, try_spree_current_user)
  end

  def load_activities
    @activities = load_product_activities(@product)
  end

  def load_product_activities(owner)
    scope = Activity.where(owner_type: owner.class.to_s, owner_id: owner.id)
    scope = scope.where("updated_at > ?", 5.days.ago).order('updated_at desc')
    scope.limit(10)
  end
end
