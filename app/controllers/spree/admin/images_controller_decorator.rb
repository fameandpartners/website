Spree::Admin::ImagesController.class_eval do
  include Spree::Admin::ImagesHelper

  private

  def load_data
    @product = Spree::Product.find_by_permalink(params[:product_id])
    @curations = @product.curations
  end

  def set_viewable
    @image.viewable = Curation.find(params[:image].delete(:viewable_id))
  end
end
