Spree::Admin::ProductsController.class_eval do
  before_filter :set_default_prototype, :only => [:new]

  def search_jackets
    scope = Spree::Product.jackets

    if params[:ids]
      product_ids = params[:ids].split(',')
      @products   = scope.where(id: product_ids)
    else
      search_params = { name_cont: params[:q], sku_cont: params[:q] }
      @products     = scope.ransack(search_params.merge(:m => 'or')).result
    end

    render 'spree/admin/products/search'
  end

  def update
    split_related_jackets_ids

    super
  end

  protected

  def location_after_save
    if params[:product][:product_customisation_types_attributes].present?
      admin_product_product_customisations_url(@product)
    else
      edit_admin_product_url(@product)
    end
  end

  def set_default_prototype
    @prototype = Spree::Product.default_prototype
  end

  def create_before
    set_default_prototype
  end

  def split_related_jackets_ids
    if ids = params[:product][:related_jacket_ids]
      params[:product][:related_jacket_ids] = ids.split(',')
    end
  end
end
