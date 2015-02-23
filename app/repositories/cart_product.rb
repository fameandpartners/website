# usage
#   Repositories::CartProduct.new(line_item: line_item).read
#   
module Repositories; end
class Repositories::CartProduct
  attr_reader :line_item, :product

  def initialize(options = {})
    @line_item  = options[:line_item]

    @product = @line_item.variant.product
  end

  def read
    @cart_product ||= begin
      result = UserCart::CartProductPresenter.new(
        id: product.id,
        name: product.name,
        description: line_item_description,
        variant_id: line_item.variant_id,
        line_item_id: line_item.id,
        product_type: product_type.to_sym,
        quantity: line_item.quantity,
        price: line_item_price,
        image: product_image
      )

      if product_has_option_values?
        result.size   = Repositories::ProductSize.read(size_id)
        result.color  = Repositories::ProductColors.read(color_id)
        result.customizations = product_customizations.to_a
      end

      result
    end
  end

  private
    
    def product_type
      return 'service' if product.service?
      customized_product? ? 'customized' : 'default'
    end

    def product_has_option_values?
      !product.service?
    end

    def customized_product?
      !product.service? && line_item.personalization.present?
    end

    def variant
      @variant ||= Repositories::ProductVariants.new(product_id: @product.id).read(@line_item.variant_id)
    end

    def color_id
      customized_product? ? line_item.personalization.color_id : variant.color_id
    end

    def size_id
      customized_product? ? line_item.personalization.size_id : variant.size_id
    end

    def product_image
      Repositories::ProductImages.new(product: product).read(color_id: color_id)
    end

    def product_customizations
      return [] if !customized_product?
      line_item.personalization.customization_values.to_a
    end

    def line_item_description
      description = product.description
      if description.present?
        description
      else
        I18n.t(:product_has_no_description)
      end 
    end

    def line_item_price
      OpenStruct.new(
        'in_sale?'.to_sym => line_item.in_sale?,
        money: line_item.money,
        money_without_discount: line_item.in_sale? ? line_item.money_without_discount : nil
      )
    end
end
