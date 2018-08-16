class Products::BaseController < ApplicationController
  include Marketing::Gtm::Controller::Collection

  rescue_from Errors::ProductInactive, with: :search_for_product_not_found
  rescue_from Errors::ProductNotFound, with: :search_for_product_not_found

  layout 'redesign/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  def search
    if( params[:q].present? && (search_term = RedirectedSearchTerm.find_by_term( params[:q].downcase.strip ) ) )
      redirect_to "#{search_term.redirect_to}?q=#{CGI::escape search_term.term}", :status => 301
    else
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
    Products::CollectionResource.new({
                                       site_version: current_site_version,
                                       query_string: params[:q],
                                       limit:        50
                                     }.merge(params.symbolize_keys)).read
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    []
  end

  def load_filters
    @filter = Products::CollectionFilter.read
  end
end
