Spree::Admin::ImagesController.class_eval do
  include Spree::Admin::ImagesHelper

  private

  def load_data
    @product = Spree::Product.find_by_permalink(params[:product_id])
    @variants = [variant_data_for(@product.master)]

    color_type_id = @product.option_types.find_by_name('dress-color').try(:id)

    color_variants = @product.variants.map do |variant|
      variant.option_values.select { |ov| ov[:option_type_id] == color_type_id }
    end.flatten.uniq

    color_data = color_variants.map do |color|
      variant_data_for(color)
    end

    @variants.insert(-1,  *color_data)
  end

  def set_viewable
    @image.viewable = viewable_by_id(@product, params[:image][:viewable_id])
  end

  def variant_data_for(viewer)
    id = "#{viewer.class.name.demodulize.underscore}_#{viewer.id}"

    label = if viewer.is_a?(Spree::Variant)
      viewer.is_master? ? I18n.t(:all) : viewer.options_text
    elsif Spree::OptionValue
      viewer.presentation
    end
    [label, id]
  end
end
