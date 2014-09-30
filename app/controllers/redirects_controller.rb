class RedirectsController < ApplicationController
  def products_index
    args = params.except(:action, :controller)
    #binding.pry

    redirect_to view_context.dresses_path(args)
  rescue
    redirect_to collection_path
  end

  # process /products/:product_id case
  # process /products/:arg1/:arg2  
  #   if no product found, trying to interpretate it as collection_id
  def products_show
    product = Spree::Product.active.find_by_permalink(params[:product_id])
    collection = get_collection_taxon(params[:collection])

    if product.present?
      # /collection/taxon/product_id
      redirect_to view_context.collection_product_path(product, params.slice(:cpt)), status: 301
    elsif collection.present?
      # /collection/taxon
      redirect_to view_context.collection_taxon_path(collection), status: 301
    else
      # /collection/taxon or /collection
      redirect_to generate_collection_path(params[:product_id], params), status: 301
    end
  rescue
    redirect_to collection_path
  end

  private 

  def generate_collection_path(collection_name = nil, params = {})
    result = nil
    args = params.except(:action, :controller, :collection, :product_id)

    collection = get_collection_taxon(collection_name)
    if collection.present?
      result ||= view_context.collection_taxon_path(collection)
    end

    #binding.pry

    result || view_context.collection_path(args)
  end

  def get_collection_taxon(collection_name)
    #binding.pry
    return nil if collection_name.blank?
    collection_taxon = view_context.range_taxonomy.root.children.where(
      "permalink like ? or name = ?", "%#{collection_name.downcase}%", collection_name.downcase
    ).first

    binding.pry

    return collection_taxon
  end
end
