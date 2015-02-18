class Products::DetailsController < Products::BaseController
  layout 'redesign/application'

  def show
    @product = Products::DetailsResource.new(
      site_version: current_site_version,
      slug:         params[:product_slug],
      permalink:    params[:id],
      color_name:   params[:color_name]
    ).read

    # only admins can view inactive/hidden products
    if !@product.is_active && !spree_current_user.try(:has_spree_role?, "admin")
      raise Errors::ProductInactive
    end

    #display_marketing_banner # content_for :banner ?

    #@title = @product.details.title
    #@title = @product.details.description
    #set_product_show_page_title(@product, @product.selected_color.presentation)

=begin
    @product.
      .properties...
      .recommended_products
      .color
      .details
        { title description }
=end
  end

=begin
  def show
    @recommended_products = get_recommended_products(@product, limit: 4)

    if params[:color_name]
      @color = Spree::OptionValue.colors.find_by_name!(params[:color_name]) rescue nil
    end

    @product = Products::ProductDetailsResource.new(
      site_version: current_site_version,
      product: @product,
      color_name: params[:color_name]
    ).read

    @is_bride = current_spree_user && current_spree_user.is_bride?

    set_product_show_page_title(@product, @product.selected_color.presentation)
    display_marketing_banner

    respond_with(@product)
  end
=end
end
