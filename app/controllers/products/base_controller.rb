class Products::BaseController < ApplicationController
  include Marketing::Gtm::Controller::Collection

  rescue_from Errors::ProductInactive, with: :search_for_product_not_found
  rescue_from Errors::ProductNotFound, with: :search_for_product_not_found

  layout 'redesign/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  def search
    title("Search results for \"#{params[:q]}\"", default_seo_title)
    load_filters
    @collection = search_results
    append_gtm_collection(@collection)
    respond_to do |format|
      format.html { render :search }
      format.json do
        render json: @collection.serialize
      end
    end
  end

  def search_for_product_not_found
    title('Page not found', default_seo_title)
    load_filters
    params[:q]  = prepare_query(params[:product_slug])
    @collection = search_results

    render :search, status: :not_found
  end

  private

  def prepare_query(product_slug)
    product_slug.to_s.match(/^(\D+)-/) { |product_name| product_name[1] }
  end

  def search_results
    if search_performed?
      Products::CollectionResource.new({
                                         site_version: current_site_version,
                                         query_string: params[:q],
                                         limit:        50
                                       }.merge(params.symbolize_keys)).read
    else
      []
    end
  rescue StandardError
    []
  end

  def search_performed?
    params[:q].present?
  end

  def load_filters
    @filter = Products::CollectionFilter.read
  end
end
