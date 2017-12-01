class Products::FlashSaleController < Products::BaseController
  include Marketing::Gtm::Controller::Collection
  respond_to :html

  layout 'custom_experience/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  def index
    if current_site_version.code != 'us'
      redirect_to '/'
    else
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
          size: li.personalization.size.presentation.split('/').first,
          color: li.personalization.color.presentation,
          customisations: li.personalization.customization_values.map {|cust| cust.presentation}
        }
      end

      respond_with @items do |format|
        format.html
      end
    end
  end

  def show
    if current_site_version.code != 'us'
      redirect_to '/'
    else
      li = Spree::LineItem.find(params[:id])
      product = li.product
      color_value_array =  li.personalization.color

      color_value = li.personalization.color.value
      if color_value.split.count('#') > 2
         color_value[0] = ''
         color_value_array = color_value.split('#')
         color_value = "linear-gradient(45deg, #{color_value_array[0]} 0%, #{color_value_array[0]} 50%, #{color_value_array[1]} 51%, #{color_value_array[1]} 100%)"
      end


      @item = {
        id: li.id,
        sku:  product.sku,
        name: product.name,
        permalink: product.permalink,
        description: product.description.gsub('<p>', '').gsub('</p>', ''),
        images: product.images.map {|image| product_images(image)},
        original_price: li.old_price,
        current_price: li.price,
        size: li.personalization.size.presentation.split('/').first,
        color_presentation: li.personalization.color.presentation,
        color_value: color_value,
        customisations: li.personalization.customization_values.map {|cust| cust.presentation}
      }
      binding.pry
      respond_with @item do |format|
        format.html
      end
    end
  end

  private

  def product_images(image)
    image.attachment.url
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

  private 

  def current_site_version
      @current_site_version ||= begin
        ::FindUsersSiteVersion.new(
            user:         current_spree_user,
            url_param:    request.env['site_version_code'],
            cookie_param: session[:site_version]
        ).get
      end
    end
end
