# usage
#   Repositories::CartProduct.new(line_item: line_item).read
#
#
require File.join(Rails.root, 'app', 'presenters', 'user_cart', 'cart_product_presenter.rb')
require File.join(Rails.root, 'app', 'models', 'customisation_value.rb')

module Repositories; end
class Repositories::CartProduct
  # include Repositories::CachingSystem
  attr_reader :line_item, :product

  def initialize(options = {})
    @line_item  = options[:line_item]

    @product = @line_item.variant.product
  end

  def read
    @cart_product ||= begin
      result = ::UserCart::CartProductPresenter.new(
        id: product.id,
        color: Repositories::ProductColors.read(color_id, product.id),
        customizations: product_customizations.to_a,
        making_options: making_options,
        height: height,
        height_value: line_item.personalization&.height_value,
        height_unit: line_item.personalization&.height_unit,
        name: line_item.style_name,
        sku: product.sku,
        permalink: product.permalink,
        description: line_item_description,
        variant_id: line_item.variant_id,
        line_item_id: line_item.id,
        line_item_sku: line_item_sku,
        product_type: product_type.to_sym,
        quantity: line_item.quantity,
        old_price: line_item_old_price,
        price: line_item_price,
        discount: product.discount.try(:amount),
        image: product_image,
        message: line_item.stock.nil? ? nil : 'Fabric swatches are final sale. US shipping only',
        standard_days_for_making: product.standard_days_for_making,
        customised_days_for_making: product.customised_days_for_making,
        default_standard_days_for_making: product.default_standard_days_for_making,
        default_customised_days_for_making: product.default_customised_days_for_making,
        delivery_period: line_item.stock.nil? ? product.delivery_period :  '5 - 7 business days', #line_item.delivery_period_policy.delivery_period,
        price_drop_au_product: price_drop_au_product?,
        fabric: line_item_fabric,
        )
      result.size  = size
      # result.color  = Repositories::ProductColors.read(color_id)
      result.customizations = product_customizations.to_a
      # result.making_options = product_making_options
      result.available_making_options = available_making_options
      result.height         = height
      result.swatch = product&.category&.category == 'Sample'
      result.path = line_item.stock.nil? ? ApplicationController.helpers.collection_product_path(result) : ApplicationController.helpers.line_item_path(line_item.id)
      result
    end
  end
  # cache_results :read

  private

    def price_drop_au_product?
      if line_item.currency == "AUD" && Features.active?(:price_drop_au)
        current_item_sku = product.sku.downcase
        price_drop_au_items_array = ["FP2062", "USP1068", "FP2006", "FP2014", "4B587", "4B398", "FP2057", "USP1006", "FP2246", "FP2144", "FP2298"]
        price_drop_au_items_array.map!(&:downcase)
        price_drop_au_items_array.include?(current_item_sku)
      end
    end

    def cache_key
      line_item.cache_key
    end

    def product_type
      customized_product? ? 'customized' : 'default'
    end

    def customized_product?
      line_item.personalization.present?
    end

    def variant
      @variant ||= Repositories::ProductVariants.read(@line_item.variant)
    end

    def color_id
      customized_product? ? line_item.personalization.color_id : variant.color_id
    end

    def size_id
      customized_product? ? line_item.personalization.size_id : variant.size_id
    end

    def product_image
      Repositories::LineItemImages.new(line_item: line_item).read(color_id: color_id, fabric_id: line_item.fabric&.id, fabric: line_item.fabric, cropped: true)
    end

    def product_customizations
      if customized_product?
        line_item.personalization.customization_values.to_a
      else
        []
      end
    end

    def height
      if line_item.product&.category&.category == 'Sample'
        nil
      elsif customized_product?
        line_item.personalization.height.presence.to_s.titleize
      else
        LineItemPersonalization::DEFAULT_HEIGHT.titleize
      end
    end

    def size
      if line_item.product&.category&.category == 'Sample'
        nil
      elsif size_id.present?
        Repositories::ProductSize.read(size_id)
      else
        nil
      end
    end

    def making_options
      line_item.making_options.includes(:product_making_option).map do |option|
        OpenStruct.new(
          id: option.id,
          option_type: option.product_making_option.option_type,
          name: option.product_making_option.name,
          display_price: option.display_price,
          display_discount: option.display_discount,
          description: option.description,
          delivery_period: option.display_delivery_period
        )
      end
    end

    # provide the available making_options to front end
    def available_making_options
      to_return = product.making_options.map do |mo|
        if line_item.stock.nil? || (mo.option_type != 'slow_making' && !mo.option_type.include?('fast_making'))
          OpenStruct.new(
            id: mo.id,
            option_type: mo.option_type,
            name: mo.name,
            display_discount: mo.display_discount,
            description: mo.description,
            delivery_period: mo.display_delivery_period,
            active: mo.active
          )
        end
      end

      puts to_return
      to_return
    end

    def line_item_description
      product.description.presence || I18n.t(:product_has_no_description)
    end

    def line_item_price
      OpenStruct.new(
        display_price: Spree::Price.new(amount: line_item.price).display_price.to_s,
        amount: line_item.price,
        currency: line_item.currency,
        'in_sale?'.to_sym => line_item.in_sale?,
        money: line_item.money,
        money_without_discount: line_item.in_sale? ? line_item.money_without_discount : nil
      )
    end

     def line_item_old_price
      if line_item.old_price
        return Spree::Price.new(amount: line_item.old_price).display_price.to_s
      else
        return nil
      end
    end

    def line_item_fabric
      if line_item.fabric
        if line_item.recommended_fabric?
          fabric_price = 0.0
        else
          fabric_price = line_item.fabric.price_in(line_item.currency)
        end

        {
        display_price: Spree::Price.new(amount: fabric_price, currency: line_item.currency).display_price,
        amount: fabric_price,
        currency: line_item.currency,
        name: line_item.fabric.presentation,
        fabric_name: line_item.fabric.name,
        value: line_item.fabric.option_fabric_color_value.value,
        custom_fabric: !line_item.recommended_fabric?
        }
      else
        nil
      end
    end

    def line_item_sku
      CustomItemSku.new(line_item).call
    end
end
