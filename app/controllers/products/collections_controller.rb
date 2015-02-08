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
    @collection = Products::CollectionResource.new(
      site_version: current_site_version,
      style: params[:style],
      event: params[:event],
      color: params[:colour] || params[:color],
      bodyshape: params[:bodyshape],
      sale:  params[:sale],
      order: params[:order],
      limit: 8
    ).read

    @filter = @collection.filter
  end
end
