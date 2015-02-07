class Products::CollectionsController < Products::BaseController
  layout 'redesign/application'

  def show
    @collection = Products::CollectionResource.new(
      site_version: current_site_version,
      limit: 8
    ).read

    @filter   = Products::CollectionFilter.read
  end
end
