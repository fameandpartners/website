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

  before_filter :set_collection_resource, :set_collection_seo_meta_data

  def show
    @filter = Products::CollectionFilter.read

    respond_to do |format|
      format.html { render :show, status: @status }
      format.json do
        render json: @collection.serialize
      end
    end
  end

  private
    def set_collection_resource
      @collection_options = parse_permalink(params[:permalink])
      @collection = collection_resource(@collection_options)
    end

    def set_collection_seo_meta_data
      # set title / meta description / HTTP status / canonical for the page
      title(@collection.details.meta_title, default_seo_title)
      @description = @collection.details.seo_description
      @status = @collection_options ? :ok : :not_found
      @canonical = dresses_path if @status == :not_found
    end

    def collection_resource(collection_options)
      resource_args = {
        site_version:   current_site_version,
        collection:     params[:collection],
        style:          params[:style],
        event:          params[:event],
        color:          params[:colour] || params[:color],
        bodyshape:      params[:bodyshape],
        discount:       params[:sale] || params[:discount],
        order:          params[:order],
        limit:          params[:limit] || 20, # page size
        offset:         params[:offset] || 0
      }.merge(collection_options || {})

      Products::CollectionResource.new(resource_args).read
    end

    # we have route like /dresses/permalink
    # where permalink can be
    #   taxon.permalink
    #   bodyshape
    #   color.name
    #   etc
    def parse_permalink(permalink)
      return {} if permalink.blank? # Note: remember the route "/*permalink". Blank means "/dresses" category

      # is should have lower priority... but we have collection='pastel' and we have colors group pastel
      color_group = Repositories::ProductColors.get_group_by_name(permalink)
      if color_group.present?
        return { color_group: color_group.name }
      end

      taxon = Repositories::Taxonomy.get_taxon_by_name(permalink)
      if taxon.present?
        # style, edits, events, range, seocollection
        case taxon.taxonomy.to_s.downcase
        when 'style', 'edits', 'event'
          return { taxon.taxonomy.to_s.downcase.to_sym => permalink }
        when 'range'
          return { collection: permalink }
        end
      end

      color = Repositories::ProductColors.get_by_name(permalink)
      if color.present?
        return { color: color.name }
      end

      # default
      return nil
    end
end
