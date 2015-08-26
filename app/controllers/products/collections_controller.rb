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
  layout 'redesign/application'
  attr_reader :page
  helper_method :page

  before_filter :redirect_undefined,
                :load_page,
                :set_collection_resource,
                :set_collection_seo_meta_data

  def show
    @filter = Products::CollectionFilter.read

    @collection.use_auto_discount!(current_promotion.discount) if current_promotion

    respond_to do |format|
      format.html { render collection_template }
      format.json do
        render json: @collection.serialize
      end
    end
  end

  private

    def redirect_undefined
      if params[:permalink] =~ /undefined\Z/
        redirect_to '/undefined', status: :moved_permanently
      end
    end

    def load_page
      current_path = LocalizeUrlService.remove_version_from_url(request.path)
      @page = Revolution::Page.find_for(current_path, '/dresses/*')
      @page.locale = current_site_version.locale
    end

    def set_collection_resource
      @collection_options = parse_permalink(params[:permalink])
      @collection = collection_resource(@collection_options)

      punch_products if product_ids
    end

    def punch_products
      products = Revolution::ProductService.new(product_ids, current_site_version).products
      @collection.products = products + @collection.products
    end

    def set_collection_seo_meta_data
      # set title / meta description for the page
      if page_is_lookbook?
        @title = "#{page.title} #{default_seo_title}"
        @description  = page.meta_description
      else
        @title = "#{@collection.details.meta_title} #{default_seo_title}"
        @description  = @collection.details.seo_description
      end
    end

    def collection_template
      if page_is_lookbook? || @collection_options
        page.template_path
      else
        { file: 'public/404', layout: false, status: :not_found }
      end
    end

    def product_ids
      params[:pids] || page.get(:pids)
    end

    def limit
      params[:limit] || page.get(:limit) || 20
    end

    def page_is_lookbook?
      page && page.get(:lookbook)
    end

    def collection_resource(collection_options)
      @resource_args = {
        site_version:   current_site_version,
        collection:     params[:collection],
        style:          params[:style],
        event:          params[:event],
        color:          params[:colour] || params[:color],
        bodyshape:      params[:bodyshape],
        discount:       params[:sale] || params[:discount],
        fast_making:    params[:fast_making],
        order:          params[:order],
        limit:          limit, # page size
        offset:         params[:offset] || 0
      }.merge(collection_options || {})
      Products::CollectionResource.new(@resource_args).read
    end


    def parse_permalink(permalink)
      return {} if permalink.blank? # Note: remember the route "/*permalink". Blank means "/dresses" category

      available_color_groups = Spree::OptionValuesGroup.for_colors.available_as_taxon
      if color_group = available_color_groups.find_by_name(permalink.downcase)
        return { color_group: color_group.name }
      end

      if taxon = Spree::Taxon.published.find_child_taxons_by_permalink(permalink)
        case taxonomy = taxon.taxonomy.name.downcase
        when 'style', 'edits', 'event'
          return { taxonomy.to_sym => permalink }
        when 'range'
          return { collection: permalink }
        end
      end

      # Didn't find any collection associated with the permalink
      return nil
    end
end
