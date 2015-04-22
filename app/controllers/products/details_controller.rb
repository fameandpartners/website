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

    # set page title.
    # Drop anything after the first period(.) and newline
    short_description = @product.short_description.gsub(/\.\W+.*\z/, ' - ')
    @title = "#{@product.name} #{default_seo_title}"
    @description = @product.short_description
  end

end
