# NOTE: current version of spree/products supports following params in url
#   
#   :root_taxon [events taxon] shows random dresses from this taxon / no other args applied
#   :sale - dresses for this sale
#   :permalink - taxon [ any ], condition
#   :event [events taxon] : with applied other args
#   :collection
#   :colour 
#   :style
#   :bodyshape
#   :lp - landing page?
# 
class Products::CollectionsController < Products::BaseController
  layout 'redesign/application'

  def show
    @filter = Products::CollectionFilter.read

    @collection = collection_resource.read

    # set title / meta description for page
    @title        = @collection.banner.title
    @description  = @collection.banner.description

    respond_to do |format|
      format.html { }
      format.json do
        render json: @collection.serialize
      end
    end
  end

  private

    def collection_resource
      resource_args = {
        site_version: current_site_version,
        collection:     params[:collection],
        style:          params[:style],
        event:          params[:event],
        color:          params[:colour] || params[:color],
        bodyshape:      params[:bodyshape],
        discount:       params[:sale] || params[:discount],
        order:          params[:order],
        limit:          12
      }.merge(parse_permalink(params[:permalink]))

      Products::CollectionResource.new(resource_args)
    end

    # we have route like /dresses/permalink
    # where permalink can be
    #   taxon.permalink
    #   bodyshape
    #   color.name
    #   etc
    def parse_permalink(permalink)
      return {} if permalink.blank?
      taxon = Repositories::Taxonomy.get_taxon_by_name(permalink)
      return {} if taxon.blank?

      # style, edits, events, range, seocollection
      case taxon.taxonomy.to_s.downcase
      when 'style', 'edits', 'event'
        { taxon.taxonomy.to_s.downcase.to_sym => permalink }
      when 'range'
        { collection: permalink }
      else
        {}
      end
    end
end
