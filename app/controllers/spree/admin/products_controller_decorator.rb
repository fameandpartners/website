Spree::Admin::ProductsController.class_eval do
  before_filter :set_default_prototype, :only => [:new]

  # def update
  #   if params[:product][:taxon_ids].present?
  #     params[:product][:taxon_ids] = params[:product][:taxon_ids].split(',')
  #   end
  #   if params[:product][:product_customisation_types_attributes].present?
  #     params[:product][:product_customisation_types_attributes].reject! do |key, attributes|
  #       %w[1 true].include?(attributes[:_destroy]) && !@object.product_customisation_types.exists?(id: attributes[:id])
  #     end
  #   end
  #   super
  # end

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
end
