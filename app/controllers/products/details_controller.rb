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
    if params[:color_name]
      color = Repositories::ProductColors.get_by_name(params[:color_name])
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
    prefix = [short_description, @product.color.try(:presentation), @product.name].compact.join(' ')
    title( [prefix, default_seo_title].compact.join(' '))
    description([@product.short_description, default_meta_description].compact.join(' '))
  end

end
