Spree::Admin::ProductsController.class_eval do
  before_filter :set_default_prototype, :only => [:new]

  def search_outerwear
    scope = Spree::Product.outerwear

    if params[:ids]
      product_ids = params[:ids].split(',')
      @products   = scope.where(id: product_ids)
    else
      search_params = { name_cont: params[:q], m: 'or' }
      @products     = scope.ransack(search_params).result
    end

    render 'spree/admin/products/search'
  end

  def update
    if params[:product][:taxon_ids].present?
      params[:product][:taxon_ids] = params[:product][:taxon_ids].split(',')
    end
    split_related_outerwear_ids

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

  def split_related_outerwear_ids
    if ids = params[:product][:related_outerwear_ids]
      params[:product][:related_outerwear_ids] = ids.split(',')
    end
  end
end
