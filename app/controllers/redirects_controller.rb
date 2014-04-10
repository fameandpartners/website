class RedirectsController < ActionController::Base
  def products_index
    redirect_to generate_collection_path(params[:collection], params), status: 301
  rescue
    redirect_to collection_path
  end

  # process /products/:product_id case
  #   if no product found, trying to interpretate it as collection_id
  def products_show
    product = Spree::Product.active.find_by_permalink(params[:product_id])
    if product.present?
      redirect_to view_context.collection_product_path(product), status: 301 
    else
      redirect_to generate_collection_path(params[:product_id], params), status: 301
    end
  rescue
    redirect_to collection_path
  end

  private 

  def generate_collection_path(collection_name = nil, params = {})
    result = nil
    args = params.except(:action, :controller, :collection, :product_id)

    if collection_name.present?
      collection_taxon = view_context.range_taxonomy.root.children.where(
        "permalink like ? or name = ?", "%#{collection_name.downcase}%", collection_name.downcase
      ).first
      if collection_taxon.present?
        result ||= view_context.collection_taxon_path(collection_taxon)
      end
    end

    result || view_context.collection_path(args)
  end
end
