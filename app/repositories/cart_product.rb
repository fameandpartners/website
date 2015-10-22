# usage
#   Repositories::CartProduct.new(line_item: line_item).read
#
#
require File.join(Rails.root, 'app', 'presenters', 'user_cart', 'cart_product_presenter.rb')
require File.join(Rails.root, 'app', 'models', 'customisation_value.rb')

module Repositories; end
class Repositories::CartProduct
  include Repositories::CachingSystem
  attr_reader :line_item, :product

  def initialize(options = {})
    @line_item  = options[:line_item]

    @product = @line_item.variant.product
  end

  def read
    @cart_product ||= begin
      result = ::UserCart::CartProductPresenter.new(
        id: product.id,
        name: product.name,
        sku: product.sku,
        permalink: product.permalink,
        description: line_item_description,
        variant_id: line_item.variant_id,
        line_item_id: line_item.id,
        product_type: product_type.to_sym,
        quantity: line_item.quantity,
        price: line_item_price,
        discount: product.discount.try(:amount),
        image: product_image
      )
      result.size   = size_id.present? ? Repositories::ProductSize.read(size_id) : nil
      result.color  = Repositories::ProductColors.read(color_id)
      result.customizations = product_customizations.to_a
      result.making_options = product_making_options

      result
    end
  #rescue
  #  OpenStruct.new({})
  end
  cache_results :read

  private

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
      @variant ||= Repositories::ProductVariants.read(@line_item.variant_id)
    end

    def color_id
      customized_product? ? line_item.personalization.color_id : variant.color_id
    end

    def size_id
      customized_product? ? line_item.personalization.size_id : variant.size_id
    end

    def product_image
      Repositories::ProductImages.new(product: product).read(color_id: color_id, cropped: true)
    end

    def product_customizations
      return [] if !customized_product?
      line_item.personalization.customization_values.to_a
    end

    def product_making_options
      line_item.making_options.includes(:product_making_option).map do |option|
        OpenStruct.new(
          id: option.id,
          option_type: option.product_making_option.option_type,
          name: option.product_making_option.name,
          display_price: option.display_price
        )
      end
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
        display_price: Spree::Price.new(amount: line_item.price).display_price.to_s,
        amount: line_item.price,
        currency: line_item.currency,
        'in_sale?'.to_sym => line_item.in_sale?,
        money: line_item.money,
        money_without_discount: line_item.in_sale? ? line_item.money_without_discount : nil
      )
    end
end
