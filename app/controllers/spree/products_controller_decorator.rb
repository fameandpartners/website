Spree::ProductsController.class_eval do
  include ApplicationHelper
  include PathBuildersHelper
  include ProductsHelper

  respond_to :html, :json
  before_filter :load_product, :only => [:show, :send_to_friend]
  #before_filter :load_activities, :only => [:show]

  after_filter :log_product_viewed

  #caches_action :show,
  #              layout: false,
  #              expires_in: configatron.cache.expire.long,
  #              cache_path: proc{ |c| c.request.url + '.' + c.request.format.ref.to_s }

  def root_taxon

    @taxons = []

    case params[:taxon_root]
    when "style"
      @title = "Shop for a specific style"
      @products_title = "Featured dresses"
      available_product_styles.each do |style|
        @taxons << {name: style.name, url: "#{style.permalink}"}
      end
    when "event"
      @title = "Shop dresses by event"
      @products_title = "Featured dresses"
      available_product_events.each do |event|
        @taxons << {name: event.name, url: "#{event.permalink}"}
      end
    when "colour"
      @title = "Shop dresses by color"
      @products_title = "Featured dresses"
      available_product_colors.each do |color|
        @taxons << {name: color.name, url: "color/#{color.name}"}
      end
    when "bodyshape"
      @title ="Shop dresses by body shape"
      @products_title = "Featured dresses"
      ProductStyleProfile::BODY_SHAPES.each do |shape|
        @taxons << {name: shape, url: "body-shape/#{shape}"}
      end
    else
      @taxons = []
    end

    @products = load_random_products amount: 8, taxon: params[:taxon_root]
  end

  def index
    @searcher = Products::ColorVariantsFilterer.new(params)

    if params[:colour].blank? && params[:style].blank?
      @sorter = Products::ColorVariantsSorter.new(@searcher.color_variants)
      @sorter.sort!
      @color_variants = @sorter.results
    else
      @color_variants = @searcher.color_variants
    end

    similar_color_variants = @searcher.similar_color_variants
    if similar_color_variants.present?
      sorter = Products::ColorVariantsSorter.new(similar_color_variants)
      sorter.sort!
      @similar_color_variants = sorter.results
    end

    @current_colors = @searcher.colour.present? ? @searcher.colors_with_similar : []

    currency = current_currency
    user = try_spree_current_user

    display_featured_dresses = params[:dfd]
    display_featured_dresses_edit = params[:dfde]

    @page_info = @searcher.selected_products_info
    @title        = @page_info[:page_title]
    @description  = @page_info[:meta_description]
    @footer_text  = @page_info[:footer_text]

    if (!display_featured_dresses.blank? && display_featured_dresses == "1") && !display_featured_dresses_edit.blank?
      @lp_featured_products = get_products_from_edit(display_featured_dresses_edit, currency, user, 4)
    end

    respond_to do |format|
      format.html do
        set_collection_title(@page_info)

        render action: 'sorting', layout: true
      end
      format.json do
        self.formats += [:html]
        products_html = render_to_string(partial: 'spree/products/color_variants')
        render json: { products_html: products_html, page_info:  @page_info }
      end
      format.xml  { render 'feeds/simple_products', products: @color_variants}
    end
  end

  def show
    @recommended_products = get_recommended_products(@product, limit: 4)

    if params[:color_name]
      @color = Spree::OptionValue.colors.find_by_name!(params[:color_name]) rescue nil
    end

    @product = Products::ProductDetailsResource.new(
      site_version: current_site_version,
      product: @product,
      color_name: params[:color_name]
    ).read

    set_product_show_page_title(@product, @product.selected_color.presentation)
    display_marketing_banner

    respond_with(@product)
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

  def load_random_products(args = {})
    root_taxon = args[:taxon]
    amount = args[:amount]



    return Spree::Product.active.all.shuffle[1..amount]
  end

  def build_page_title(params)

  end

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
end
