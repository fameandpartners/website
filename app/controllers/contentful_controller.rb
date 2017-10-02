class ContentfulController < ApplicationController
  # include ContentfulHelper
  # include ContentfulService

  layout 'contentful/application'

  attr_reader :page, :banner
  helper_method :page, :banner

  # before_filter :load_page,
  #               :set_collection_resource

  def main
    current_contently = Contentful::Version.fetch_payload(params['developer'] == 'preview')

    @landing_page_container = current_contently[request.path]

    if @landing_page_container
      get_all_pids
      load_page
      set_collection_resource
      render 'layouts/contentful/main'
    else
      render_404
    end
  end

  def get_all_pids
    @pids_array = @landing_page_container.to_json.scan(/\"([0-9]+[+\-a-z]+)/).flatten.uniq
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
    products             = Revolution::ProductService.new(@pids_array, current_site_version).products(params, page.effective_page_limit)
    @collection.products = if page.get('curated') && product_ids.size > 0
                             @collection.total_products = product_ids.size
                             products
                           else
                             @collection.total_products += product_ids.size
                             (products.first.blank? ? @collection.products : products + @collection.products)
                           end
  end

  def product_ids
    params_pids = case params[:pids]
                    when Hash
                      params[:pids].values
                    else
                      Array.wrap(params[:pids])
                  end

    page_pids = page.get(:pids).to_s.split(',')
    params_pids.empty? ? page_pids : params_pids
  end

  def set_collection_resource
    @collection_options = parse_permalink(params.fetch(:permalink, params[:q]))
    if @collection_options.blank? && (params[:permalink] != params[:q])
      @query_string = params[:q]
    end

    @collection         = collection_resource(@collection_options)
    page.collection     = @collection
    punch_products
  end

  def collection_resource(collection_options = {})
    resource_args = filter_options.merge(collection_options || {})
    resource_args.update(all_style_options(resource_options: resource_args))
    Products::CollectionResource.new(resource_args).read
  end

  # private

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
