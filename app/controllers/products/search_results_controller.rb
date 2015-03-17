class Products::SearchResultsController < Products::BaseController
  layout 'redesign/application'

  def show
    @query_string = params[:q]

    @products = Search::ProductsQuery.build(
      query: @query_string
    ).results.results
  end
end
