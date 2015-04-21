class Products::SearchResultsController < Products::BaseController
  layout 'redesign/application'

  attr_reader :results
  helper_method :search_performed?, :results


  def show
    title("Search results for \"#{params[:q]}\"", default_seo_title)

    @results = if search_performed?
       Products::CollectionResource.new({
        site_version: current_site_version,
        query_string: params[:q],
        limit:        50
      }).read
    else
      []
    end
  rescue StandardError
    @results = []
  end

  private
  def search_performed?
    params[:q].present?
  end
end
