module Repositories
class CartItem
  attr_reader :line_item, :variant, :product

  def initialize(options = {})
    @line_item  = options[:line_item]
    @variant    = options[:variant] || @line_item.variant
    @product    = options[:product] || @variant.product
  end

  def read
    OpenStruct.new(
      id: line_item.id,
      name: product.name,
      sku: product.sku,
      variant_id: variant.id,
      description: line_item_description,
      image: line_item_image,
      size: line_item_size,
      color: line_item_color,
      product_type: product_type.to_sym,
      quantity: line_item.quantity,
      customizations: product_customizations,
      # collection product path support
      product: OpenStruct.new(id: product.id, name: product.name),
      # price_for_line_item price support
      line_item: OpenStruct.new(
        'in_sale?'.to_sym => line_item.in_sale?,
        money: line_item.money,
        money_without_discount: line_item.in_sale? ? line_item.money_without_discount : nil
      )
    )
  end

  private

    def product_type
      customized_product? ? 'customized' : 'default'
    end

    def customized_product?
      line_item.personalization.present?
    end

    def line_item_color
      @line_item_color ||= begin
        if customized_product?
          line_item.personalization.color
        else
          variant.dress_color
        end
      end
    end

    def line_item_size
      @line_item_size ||= begin
        if customized_product?
          line_item.personalization.size
        else
          variant.dress_size
        end
      end
    end

    def product_images
      @product_images ||= Repositories::ProductImages.new(product: product).read_all(
        color_id: line_item_color&.id,
        cropped: true,
        product_customizations: line_item.personalization&.customization_values,
        fabric: line_item.fabric
      )
    end

    def line_item_image
      image = nil
      if line_item_color.present?
        image ||= product_images.find{|image| image.color_id == line_item_color.id }
      end
      image ||= product_images.first
    end

    def line_item_description
      description = product.description
      if description.present?
        description
      else
        I18n.t(:product_has_no_description)
      end
    end

    def product_customizations
      return [] if !customized_product?
      line_item.personalization.customization_values
    end
end
end
