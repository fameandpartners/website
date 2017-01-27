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
        line_item_sku: line_item_sku,
        product_type: product_type.to_sym,
        quantity: line_item.quantity,
        price: line_item_price,
        discount: product.discount.try(:amount),
        image: product_image,
        standard_days_for_making: product.standard_days_for_making,
        customised_days_for_making: product.customised_days_for_making,
        default_standard_days_for_making: product.default_standard_days_for_making,
        default_customised_days_for_making: product.default_customised_days_for_making,
        delivery_period: product.delivery_period,
        is_wedding_atelier_product: product.is_wedding_atelier_product?
      )
      result.size   = size_id.present? ? Repositories::ProductSize.read(size_id) : nil
      result.color  = Repositories::ProductColors.read(color_id)
      result.customizations = product_customizations.to_a
      result.making_options = product_making_options
      result.height         = height

      result
    end
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
      if product.is_wedding_atelier_product?
        WeddingAtelier::EventDress.images_for_line_item(line_item)
      else
        Repositories::ProductImages.new(product: product).read(color_id: color_id, cropped: true)
      end
    end

    def product_customizations
      if customized_product?
        line_item.personalization.customization_values.to_a
      else
        []
      end
    end

    def height
      if customized_product?
        line_item.personalization.height.presence.to_s.titleize
      else
        LineItemPersonalization::DEFAULT_HEIGHT.titleize
      end
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

    def line_item_sku
      CustomItemSku.new(line_item).call
    end
end
