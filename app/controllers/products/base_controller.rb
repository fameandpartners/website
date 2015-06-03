class Products::BaseController < ApplicationController
  rescue_from Errors::ProductInactive, with: :search_for_product_not_found
  rescue_from Errors::ProductNotFound, with: :search_for_product_not_found

  layout 'redesign/application'

  def search
    title("Search results for \"#{params[:q]}\"", default_seo_title)
    @results = search_results
    render :search
  end

  def search_for_product_not_found
    title('Page not found', default_seo_title)
    # TODO: the product_slug param will change on PR 311 (https://github.com/fameandpartners/website/pull/311)
    params[:q] = prepare_query(params[:product_slug])
    @results = search_results
    render :search, status: :not_found
  end

  private

  def prepare_query(product_slug)
    if product_name = product_slug.to_s.match(/^(\D+)-/)
      product_name[1]
    end
  end

  def search_results
    if search_performed?
       Products::CollectionResource.new({
        site_version: current_site_version,
        query_string: params[:q],
        limit:        50
      }).read
    else
      []
    end
  rescue StandardError
    []
  end

  def search_performed?
    params[:q].present?
  end
  helper_method :search_performed?
end
