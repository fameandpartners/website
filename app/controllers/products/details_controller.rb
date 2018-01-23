class Products::DetailsController < Products::BaseController
  include Marketing::Gtm::Controller::Product
  include ProductsHelper

  layout 'custom_experience/application'

  def show
    @zopim_opt_out = true
    @optimizely_opt_in = true
    @product = setup_product(params)
    @user = spree_current_user || {}

    # Set SEO properties
    # Drop anything after the first period(.) and newline
    title(@product.meta_title, default_seo_title)
    description(@product.meta_description)

    append_gtm_product(product_presenter: @product)

    render :show, status: pdp_status
  end

  def bridesmaid_show
    @swatch_colors = fabric_swatch_colors.to_json
    customized_product = CustomizationVisualization.find(params[:id])
    base_product = customized_product.product
    length_name = "change-to-#{customized_product.length.downcase}"

    length_cust = JSON.parse(base_product.customizations).select{ |x| x['customisation_value']['name'] == length_name}

    @bridesmaid_data = {
      product: setup_bridesmaid_product(base_product),
      incompatible_ids: customized_product.incompatible_ids.split(','),
      image_urls: JSON.parse(customized_product.render_urls).select {|x| x['color'] == params[:color]},
      selected_customizations: customized_product.customization_ids.split('_') | length_cust.map{ |x| x['customisation_value']['id'] }
      # available_lengths: JSON.parse(base_product.lengths)['available_lengths']
    }

    @product = @bridesmaid_data[:product]
    @zopim_opt_out = true
    @user = spree_current_user || {}

    # Set SEO properties
    # Drop anything after the first period(.) and newline
    title(@bridesmaid_data[:product].meta_title, default_seo_title)
    description(@bridesmaid_data[:product].meta_description)

    append_gtm_product(product_presenter: @bridesmaid_data[:product])

    render :bridesmaid_show, status: bridesmaid_pdp_status
  end

  private

  def setup_product(params)
    product = Products::DetailsResource.new(
      site_version: current_site_version,
      slug:         params[:product_slug],
      permalink:    params[:id]
    ).read

    # only admins can view deleted products
    if product.is_deleted && !spree_current_user.try(:has_spree_role?, "admin")
    raise Errors::ProductInactive
    end

    # set preselected images colors
    color_hash = \
      if params[:color]
        Repositories::ProductColors.get_by_name(params[:color]) || {}
      else
        # select images of one/default color
        color = product.available_options.colors.default.first

        {
          id:   color&.id,
          name: color&.name
        }
      end

    product.color_id   = color_hash[:id]
    product.color_name = color_hash[:name]

    # todo: thanh 4/3/17- why would we want to default this following line
    # make express delivery as default option
    product.making_option_id = product.making_options.first.try(:id)

    product.use_auto_discount!(current_promotion.discount) if current_promotion

    if product.fit
      product.fit = product.fit.gsub(" Height", "Height")
      product.fit = product.fit.gsub("Height", ", Height")
      product.fit = product.fit.gsub(" Hips", "Hips")
      product.fit = product.fit.gsub("Hips", ", Hips")
      product.fit = product.fit.gsub(" Waist","Waist")
      product.fit = product.fit.gsub("Waist",", Waist")
    end
    return product
  end

  def setup_bridesmaid_product(prod)
    product = Products::DetailsResource.new(
      site_version: current_site_version,
      permalink:    prod.permalink
    ).read

    # only admins can view deleted products
    if product.is_deleted && !spree_current_user.try(:has_spree_role?, "admin")
    raise Errors::ProductInactive
    end

    # set preselected images colors
    color_hash = \
      if params[:color]
        Repositories::ProductColors.get_by_name(params[:color]) || {}
      else
        # select images of one/default color
        color = product.available_options.colors.default.first

        {
          id:   color&.id,
          name: color&.name
        }
      end

    product.color_id   = color_hash[:id]
    product.color_name = color_hash[:name]

    # todo: thanh 4/3/17- why would we want to default this following line
    # make express delivery as default option
    product.making_option_id = product.making_options.first.try(:id)

    product.use_auto_discount!(current_promotion.discount) if current_promotion

    if product.fit
      product.fit = product.fit.gsub(" Height", "Height")
      product.fit = product.fit.gsub("Height", ", Height")
      product.fit = product.fit.gsub(" Hips", "Hips")
      product.fit = product.fit.gsub("Hips", ", Hips")
      product.fit = product.fit.gsub(" Waist","Waist")
      product.fit = product.fit.gsub("Waist",", Waist")
    end
    return product
  end


  def pdp_status
    @product.is_active ? :ok : :not_found
  end

  def bridesmaid_pdp_status
    @bridesmaid_data[:product].is_active ? :ok : :not_found
  end
end
