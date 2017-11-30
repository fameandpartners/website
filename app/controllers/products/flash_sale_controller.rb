class Products::FlashSaleController < Products::BaseController
  include Marketing::Gtm::Controller::Collection
  respond_to :html

  layout 'custom_experience/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  def index
    @filter = Products::CollectionFilter.read

    if params[:sort]
      line_items = Spree::LineItem.where(stock: true).order("price #{params[:sort]}").page(params[:page]).per(100)
    else
      line_items = Spree::LineItem.where(stock: true).order(:price).page(params[:page]).per(100)
    end

    line_items = line_items.where(color: params[:color]) if params[:color]
    line_items = line_items.where(size: params[:size]) if params[:size]
    line_items = line_items.where(length: params[:length]) if params[:length]

    @items = line_items.map do |li|
      product = li.product
      {
        id: li.id,
        sku:  product.sku,
        name: product.name,
        permalink: product.permalink,
        description: product.description,
        images: product_images(product),
        original_price: li.old_price,
        current_price: li.price,
        size: li.personalization.size.presentation,
        color:li.personalization.color.presentation,
        customisations: li.personalization.customization_values.map {|cust| cust.presentation}
      }
    end

    respond_with @items do |format|
      format.html
    end
  end

  def show
    li = Spree::LineItem.find(params[:id])
    product = li.product

    @item = {
      id: li.id,
      sku:  product.sku,
      name: product.name,
      permalink: product.permalink,
      description: product.description,
      images: product_images(product),
      original_price: li.old_price,
      current_price: li.price,
      size: li.personalization.size.presentation,
      color:li.personalization.color.presentation,
      customisations: li.personalization.customization_values.map {|cust| cust.presentation}
    }

    respond_with @item do |format|
      format.html
    end
  end

  private

  def product_images(product)
    @product_images ||= Repositories::ProductImages.new(product: product)
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
