class Products::SearchResultsController < Products::BaseController
  layout 'redesign/application'

  def show
    title('Search', default_seo_title)

    if params[:q].present?
      @search_collection = Products::CollectionResource.new({
        site_version: current_site_version,
        query_string: params[:q],
        limit:        50
      }).read
    end
  end
end
