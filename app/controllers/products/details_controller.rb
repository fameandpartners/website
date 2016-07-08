class Products::DetailsController < Products::BaseController
  include Marketing::Gtm::Controller::Product
  include Marketing::Gtm::Controller::Event

  layout 'redesign/application'

  def show
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
    if params[:color]
      color = Repositories::ProductColors.get_by_name(params[:color])
    else
      # select images of one/default color
      color = @product.available_options.colors.default.first
    end

    @product.color_id   = color.try(:id)
    @product.color_name = color.try(:name)
    # @product.color = color

    # make express delivery as default option
    @product.making_option_id = @product.making_options.first.try(:id)

    @product.use_auto_discount!(current_promotion.discount) if current_promotion

    # Set SEO properties
    # Drop anything after the first period(.) and newline
    @title       = "#{@product.meta_title} #{default_seo_title}".strip
    @description = @product.meta_description
    append_gtm_product(product_presenter: @product)

    Activity.log_product_viewed(@product, temporary_user_key, try_spree_current_user)

    load_my_things_pixel
  end

  private

  def load_my_things_pixel
    append_gtm_event(event_name: 'product_page')
    @gtm_container.append_single_variable('product_id', @product.id)
  end

end
