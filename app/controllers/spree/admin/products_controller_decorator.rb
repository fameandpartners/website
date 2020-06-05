require 'csv'

Spree::Admin::ProductsController.class_eval do
  before_filter :set_default_prototype, :only => [:new]
  before_filter :split_related_outerwear_ids, :only => [:update]

  def export_product_taxons
    scope = Spree::Product.includes(:taxons, :variants_including_master)

    csv_headers = ['Product Name', 'Product Style', 'Price', 'Manufacturer', 'Taxons']
    csv_file    = CSV.generate(write_headers: true, headers: csv_headers) do |csv|
      scope.each do |p|
        csv << [p.name, p.sku, p.site_price_for(Spree::Config.currency), p.factory&.name, p.taxons.pluck(:name).join(',')]
      end
    end

    respond_to do |format|
      format.csv { send_data csv_file, filename: 'all_products_taxons.csv', type: :csv }
    end
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
