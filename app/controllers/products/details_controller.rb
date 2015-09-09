class Products::DetailsController < Products::BaseController
  layout 'redesign/application'

  def show
    @product = Products::DetailsResource.new(
      site_version: current_site_version,
      slug:         params[:product_slug],
      permalink:    params[:id]
    ).read

    # only admins can view inactive/hidden products
    if !@product.is_active && !spree_current_user.try(:has_spree_role?, "admin")
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

    # set page title.
    # Drop anything after the first period(.) and newline
    color_title = params[:color].titleize if params[:color]
    @title = "#{color_title} #{@product.name} #{default_seo_title}".strip
    @description = product_description
  end

  def product_description
    "#{@product.short_description} #{@product.price_with_currency}"
  end
end
