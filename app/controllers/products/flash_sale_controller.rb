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
        line_items = Spree::LineItem.where(stock: true).order("price #{params[:sort]}")
      else
        line_items = Spree::LineItem.where(stock: true).order(:price)
      end

      line_items = line_items.where(color: params[:color]) if params[:color]
      line_items = line_items.where(size: params[:size]) if params[:size]
      if params[:length]
        leng = params[:length].map{|x| x.capitalize}
        line_items = line_items.where(length: leng) 
      end
      total_pages = (line_items.count.to_f/96.0).ceil
      line_items = line_items.page(params[:page]).per(96)
      @items = line_items.map do |li|
        product = li.product
        {
          id: li.id,
          sku:  product.sku,
          name: product.name,
          permalink: product.permalink,
          description: product.description,
          images:  get_cropped_image(product.images.map {|image| image_data(image)}).map {|x| x[:large]}.sort_by{|x| x.index('front')}.reverse,
          original_price: li.old_price,
          current_price: li.price,
          height: li.personalization.height.capitalize,
          size: li.personalization.size.presentation.split('/').first,
          color: li.personalization.color.presentation,
          customisations: li.personalization.customization_values.map {|cust| cust.presentation},
          total_pages: total_pages
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
      if li.stock.nil?
        redirect_to '/'
      end
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
        description: product.description.gsub('<p>', '').gsub('</p>', '').gsub('<br>', '').gsub('</br>', '').gsub('<br />', '').gsub('<br/>', ''),
        images:  get_pdp_images(product.images.map {|image| image_data(image)[:large]}),
        original_price: li.old_price,
        current_price: li.price,
        size: li.personalization.size.presentation.split('/').first,
        height: li.personalization.height.capitalize,
        color_presentation: li.personalization.color.presentation,
        color_value: color_value,
        customisations: li.personalization.customization_values.map {|cust| cust.presentation}
      }
      respond_with @item do |format|
        format.html
      end
    end
  end

  private

    # helper method
  def image_data(image)
    {
      id: image.id,
      position: image.position,
      original: image.attachment.url(:original),
      product: image.attachment.url(:product),
      large: image.attachment.url(:large),
      xlarge: image.attachment.url(:xlarge),
      small: image.attachment.url(:small)
    }
  end

  def get_cropped_image(images)
     cropped_images = images.select{ |i| i[:large].to_s.downcase.include?('crop') }

     if cropped_images.blank?
       cropped_images = images.select { |i| i[:large].to_s.downcase.include?('front') }
     end
     cropped_images

 end
  

  def get_pdp_images(images)
    pdp_images = images.select {|x| x.include?('crop.jpg')}

    pdp_images
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
