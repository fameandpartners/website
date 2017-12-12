# NOTE: current version of spree/products supports following params in url
#
#   :root_taxon [events taxon] shows random dresses from this taxon / no other args applied
#   :sale - dresses for this sale
#   :permalink - taxon [ any ], condition
#   :event [events taxon] : with applied other args
#   :collection
#   :color
#   :style
#   :bodyshape
#   :lp - landing page?
#   :fast_making - only items with available express making
#
# Date is from the parent taxon
# Banner text over the image in the collection header:
#
#     heading should be from the Parent Taxon Banner title
#     subheading should be from the Parent Taxon Banner description
#
# Content blocks in the page:
#
#     description should come from the Taxon description
#     footer should come from Banner footer text
#
# In the meta tags:
#     title == taxon.meta_title
#     meta description should come from Banner Seo Description
#

class Products::CollectionsController < Products::BaseController
  include Marketing::Gtm::Controller::Collection

  layout 'redesign/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version,
                :canonicalize_sales,
                :load_page,
                :set_collection_resource,
                :set_collection_seo_meta_data

  def show
    # for Best Sellers A/B testing...
    @facebook_ranking_opt_in = true

    @vwo_opt_in = false
    @zopim_opt_out = true
    @filter = Products::CollectionFilter.read
    @collection.use_auto_discount!(current_promotion.discount) if current_promotion && current_promotion.code.downcase != 'deliverydisc'

    respond_to do |format|
      format.html { render collection_template }
      format.json do
        render json: @collection.serialize
      end
    end
  end

  private

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

  def canonicalize_sales
    @canonical = dresses_path if params[:sale]
  end

  def product_ids
    params_pids = case params[:pids]
                    when Hash
                      params[:pids].values
                    else
                      Array.wrap(params[:pids])
                  end

    page_pids = page.get(:pids).to_s.strip.split(',')
    pids = params_pids.empty? ? page_pids : params_pids
    pids&.uniq
  end

  def set_collection_resource
    @collection_options = parse_permalink(params.fetch(:permalink, params[:q]))
    if @collection_options.blank? && (params[:permalink] != params[:q])
      @query_string = params[:q]
    end

    @collection         = collection_resource(@collection_options)
    page.collection     = @collection
    punch_products unless product_ids.empty?

    append_gtm_collection(@collection)
  end

  def load_page
    current_path = LocalizeUrlService.remove_version_from_path(request.path)
    @page        = Revolution::Page.find_for(current_path, '/dresses/*') || Revolution::Page.default_page
    page.params  = params
    page.locale  = current_site_version.locale
    @banner      = Revolution::PageBannerDecorator.new(page, params)
  end

  def punch_products
    return if filters_applied?

    products             = Revolution::ProductService.new(product_ids, current_site_version).products(params, page.effective_page_limit)
    @collection.products = if page.get('curated') && product_ids.size > 0
                             @collection.total_products = product_ids.size
                             products
                           else
                             @collection.total_products += product_ids.size
                             (products.first.blank? ? @collection.products : products + @collection.products)
                           end
  end

  def set_collection_seo_meta_data
    title(page.title, default_seo_title)
    description(page.meta_description)
  end

  def collection_template
    if page.page_is_lookbook? || @collection_options
      page.template_path
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def collection_resource(collection_options = {})
    resource_args = filter_options.merge(collection_options || {})
    resource_args.update(all_style_options(resource_options: resource_args))
    Products::CollectionResource.new(resource_args).read
  end

  private

  def parse_permalink(permalink)
    # Note: remember the route "/*permalink".
    return {} if permalink.blank?

    # Color groups as categories
    if (color_group = Spree::OptionValuesGroup.for_colors.available_as_taxon.where(name: permalink).first)
      return { color_group: color_group.name }
    end

    # Taxons as categories
    if (taxon = Spree::Taxon.published.find_child_taxons_by_permalink(permalink))
      case taxonomy = taxon.taxonomy.name.downcase
        when 'style', 'edits', 'event'
          return { taxonomy.to_sym => permalink }
        when 'range'
          return { collection: permalink }
      end
    end

    # Outerwear
    outerwear_permalink = Spree::Taxonomy::OUTERWEAR_NAME.parameterize
    if outerwear_permalink == permalink
      return {outerwear: outerwear_permalink, show_outerwear: true}
    end

    # Didn't find any collection associated with the permalink
    nil
  end

  def all_style_options(resource_options:)
    resource_styles = Array.wrap(resource_options[:style])
    filter_styles   = Array.wrap(filter_options[:style])

    {
      style: resource_styles | filter_styles
    }
  end

  def filter_options
    custom_product_ids = filters_applied? ? [] : product_ids
    {
      site_version:                    current_site_version,
      collection:                      params[:collection],
      style:                           params[:style],
      event:                           params[:event],
      color:                           params[:colour] || params[:color],
      color_groups:                    params[:color_group],
      bodyshape:                       params[:bodyshape],
      discount:                        params[:sale] || params[:discount],
      fast_making:                     params[:fast_making],
      order:                           params[:order] || page.product_order,
      limit:                           page.limit(custom_product_ids), # page size
      offset:                          page.offset(custom_product_ids, params[:offset]),
      price_min:                       params[:price_min],
      price_max:                       params[:price_max],
      query_string:                    @query_string,
      # TODO: delete this bad named variable: "remove_excluded_from_site_logic".
      remove_excluded_from_site_logic: page.get(:remove_excluded_from_site_logic)
    }
  end

  def filters_applied?
    params.slice(
      :collection, :style, :event, :color, :colour, :bodyshape, :order, :q, :price_min, :price_max
    ).values.any?(&:present?)
  end
end
