class Products::DetailsController < Products::BaseController
  include Marketing::Gtm::Controller::Product

  before_filter :setup_product, only: [:show, :show_json]

  layout 'custom_experience/application'

  def show

    #TODO: Possibly no longer needed??

    @zopim_opt_out = true

    # Set SEO properties
    # Drop anything after the first period(.) and newline
    title(@product.meta_title, default_seo_title)
    description(@product.meta_description)

    append_gtm_product(product_presenter: @product)

    # @partial_hash = Rails.cache.fetch(env["ORIGINAL_FULLPATH"]+current_site_version.name, expires_in: 14.hours) do
    #   #let's makey object for nodepdp
    #   pdp_obj = {
    #     paths: env["REQUEST_URI"],  #todo: work this out with adam
    #     product: @product,
    #     discount: @product_discount,
    #     images: @product.all_images,
    #     sizeChart: @product.size_chart_data,
    #     siteVersion: @current_site_version.name,
    #     svgSpritePath: "/assets/svg/sprite.svg",
    #     flags: {
    #       afterpay: Features.active?(:afterpay),
    #       fastMaking: !Features.active?(:getitquick_unavailable)
    #     }
    #   }

    #   begin
    #     resp = RestClient.post "#{configatron.node_pdp_url}/pdp", {'data' => pdp_obj}.to_json, {content_type: :json}
    #     JSON.parse(resp)
    #   rescue Exception => e
    #     Raven.capture_exception(e, response: resp)
    #     NewRelic::Agent.notice_error(e, response: resp)
    #     throw e
    #   end
    # end

    render :show, status: pdp_status
  end

  def show_json
    # TODO: Cache this json response
    # TODO: Add test coverage

    pdp_obj = {
      paths: env["REQUEST_URI"],  #todo: work this out with adam
      product: @product,
      discount: @product_discount,
      images: @product.all_images,
      sizeChart: @product.size_chart_data,
      siteVersion: @current_site_version.name,
      svgSpritePath: "/assets/svg/sprite.svg",
      flags: {
        afterpay: Features.active?(:afterpay),
        fastMaking: !Features.active?(:getitquick_unavailable)
      }
    }
    render json: pdp_obj
  end

  private

  def setup_product
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

    if @product.fit
      @product.fit = @product.fit.gsub(" Height", "Height")
      @product.fit = @product.fit.gsub("Height", ", Height")
      @product.fit = @product.fit.gsub(" Hips", "Hips")
      @product.fit = @product.fit.gsub("Hips", ", Hips")
      @product.fit = @product.fit.gsub(" Waist","Waist")
      @product.fit = @product.fit.gsub("Waist",", Waist")
    end
  end


  def pdp_status
    @product.is_active ? :ok : :not_found
  end
end
