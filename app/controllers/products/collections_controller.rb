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

    @collection = Products::CollectionResource.new(
      site_version: current_site_version,
      style:        params[:style],
      event:        params[:event],
      color:        params[:colour] || params[:color],
      bodyshape:    params[:bodyshape],
      discount:     params[:sale] || params[:discount],
      order:        params[:order],
      limit:        12
    ).read

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
end
