class Products::FlashSaleController < Products::BaseController
  include Marketing::Gtm::Controller::Collection

  layout 'redesign/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  def index
    line_items = Spree::LineItem.where(stock: true)

    items = @line_items.map do |li|
      product = li.product
      OpenStruct.new({
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
      }).marshall_dump
    end
    
    respond_to do |format|
      format.html { }
      format.json do
        render json: items
      end
    end
  end

  def show
    li = Spree::LineItem.find(params[:id])

    item = OpenStruct.new({
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
      })
    
    respond_to do |format|
      format.html { }
      format.json do
        render json: item.marshall_dump
      end
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
