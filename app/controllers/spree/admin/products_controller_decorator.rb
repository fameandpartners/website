require 'csv'
Spree::Admin::ProductsController.class_eval do
  before_filter :set_default_prototype, :only => [:new]
  before_filter :split_related_outerwear_ids, :only => [:update]
  respond_to :csv, only: [:export_product_taxons_csv]

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

  def export_product_taxons_csv
    all_products = Spree::Product.includes(:taxons)

    csv = CSV.generate(col_sep: ',') do |csv|
      csv << ['Product Name',
              'Taxons']
      all_products.each do |p|
        csv << [p.name,
                p.taxons.pluck(:name).join(",")]
      end
    end
    send_data csv, filename: "all_products_taxons.csv", type: :csv
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
