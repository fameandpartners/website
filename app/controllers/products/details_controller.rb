class Products::DetailsController < Products::BaseController
  include Marketing::Gtm::Controller::Product

  layout 'redesign/application'

  def show
    @zopim_opt_out = true

    @product = Products::DetailsResource.new(
      site_version: current_site_version,
      slug:         params[:product_slug],
      permalink:    params[:id]
    ).read

    # only admins can view deleted products
    if @product.is_deleted && !spree_current_user.try(:has_spree_role?, "admin")
      raise Errors::ProductInactive
    end

    # set preselected images colors

    color_hash = \
      if params[:color]
        Repositories::ProductColors.get_by_name(params[:color]) || {}
      else
        # select images of one/default color
        color = @product.available_options.colors.default.first

        {
          id:   color&.id,
          name: color&.name
        }
      end

    @product.color_id   = color_hash[:id]
    @product.color_name = color_hash[:name]

    # todo: thanh 4/3/17- why would we want to default this following line
    # make express delivery as default option
    @product.making_option_id = @product.making_options.first.try(:id)

    @product.use_auto_discount!(current_promotion.discount) if current_promotion

    # Set SEO properties
    # Drop anything after the first period(.) and newline
    title(@product.meta_title, default_seo_title)
    description(@product.meta_description)

    append_gtm_product(product_presenter: @product)

    #let's makey object for nodepdp
    pdp_obj = {
      paths: env["REQUEST_URI"],  #temporary
      product: @product,
      discount: @product_discount,
      images: @product.all_images,
      sizeChart: @product.size_chart_data,
      siteVersion: @current_site_version.name,
      flags: {
        afterpay: Features.active?(:afterpay),
        fastMaking: !Features.active?(:getitquick_unavailable)
      }
    }

    resp = RestClient.post "http://localhost:8001/pdp", {'data' => pdp_obj}.to_json, {content_type: :json}
    @partial_hash = JSON.parse(resp)

    render :show, status: pdp_status
  end

  private def pdp_status
    @product.is_active ? :ok : :not_found
  end
end
