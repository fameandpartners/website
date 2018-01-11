# reason to extract - old line_items#create is overgrown. and not manageable
# reason not to extract, not writing any tests.
#
# usage
#    cart_populator = UserCart::Populator.new(
#      order: current_order(true),
#      site_version: current_site_version,
#      currency: current_currency,
#      product: {
#        variant_id: params[:variant_id],
#        size_id: params[:size_id],
#        color_id: params[:color_id],
#        customizations_ids: params[:customizations_ids],
#        making_options_ids: params[:making_options_ids],
#        quantity: 1
#      }
#    )
module UserCart
class Populator
  attr_reader :site_version, :order, :currency, :product_attributes

  def initialize(options = {})
    @order            = options[:order]
    @site_version     = options[:site_version] || SiteVersion.default
    @currency         = options[:currency]  || site_version.try(:currency)
    @product_attributes = HashWithIndifferentAccess.new(options[:product] || {})
  end

  def populate
    validate!
    if personalized_product?
      add_personalized_product
    else
      add_product_to_cart
    end

    order.update!
    order.reload

    return OpenStruct.new({
      success: true,
      product: product,
      cart_product: Repositories::CartProduct.new(line_item: line_item).read
    })
  rescue Errors::ProductOptionsNotCompatible, Errors::ProductOptionNotAvailable, StandardError => e
    begin
      err_attrs = {
        :order              => @order.to_h,
        :site_version       => @site_version.to_h,
        :product_attributes => @product_attributes
      }
      NewRelic::Agent.notice_error(e, err_attrs)
    rescue StandardError
      #turtles
    end
    OpenStruct.new({ success: false, message: e.message, attrs: err_attrs })
  end

  private
    # thanh is flagging this method for destruction: confirms with the tanias about custom colors
    def validate!
      if product_color.custom && product_making_options.present?
        raise Errors::ProductOptionsNotCompatible.new("Custom colors and fast delivery can't be selected at the same time")
      end
    end

    def add_product_to_cart
      spree_populator = Spree::OrderPopulator.new(order, currency)

      if spree_populator.populate(variants: { product_variant.id => product_quantity })
        add_making_options

        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')
        true
      else
        false
      end
    end

    def add_personalized_product
      personalization = build_personalization
      if personalization.valid?
        add_product_to_cart
        personalization.line_item = line_item
        line_item.personalization = personalization
        personalization.save
      end

      true
    end

    def add_making_options
      return if line_item.blank? || product_making_options.blank?
      line_item.making_options = product_making_options.collect do |making_option|
        LineItemMakingOption.build_option(ProductMakingOption.find(making_option.id))
      end
      line_item
    end

    def build_personalization
      LineItemPersonalization.new.tap do |item|
        item.size_id  = product_size.id
        item['size']  = product_size.value
        item.color_id = product_color.color_id
        item['color'] = product_color.color_name
        item.customization_value_ids = product_customizations.map(&:id)
        item.product_id = product.id

        if product_attributes[:height].present?
          item.height = product_attributes[:height]
        else
          item.height_value = product_attributes[:height_value]
          item.height_unit = product_attributes[:height_unit]
          item.height = StyleToProductHeightRangeGroup.map_height_values_to_height_name( product_variant, product_attributes[:height_value], product_attributes[:height_unit] )
        end
      end
    end

    def personalized_product?
      product_variant.is_master? || product_color.custom? || product_size.custom || product_customizations.present? || custom_height?
    end

    def custom_height?
      height = product_attributes[:height].to_s
      height.present? && height != LineItemPersonalization::DEFAULT_HEIGHT
    end

    def product
      @product ||= product_variant.product
    end

    def product_variant
      @variant ||= Spree::Variant.where(id: product_attributes[:variant_id]).first
    end

    def line_item
      # Sorted by created at to ensure it is the last created line item
      @line_item ||= Spree::LineItem.where(order_id: order.id, variant_id: product_variant.id).order('created_at desc').first
    end

    def product_options
      @product_options = Products::SelectionOptions.new(site_version: site_version, product: product).read
    end

    def product_size
      @product_size ||= begin
        product_size_id = product_attributes[:size_id].to_i
        if (size = product_options.sizes.default.detect{|size| size.id == product_size_id}).present?
          size.custom = false
        elsif (size = product_options.sizes.extra.detect{|size| size.id == product_size_id}).present?
          size.custom = true
        else
          raise Errors::ProductOptionNotAvailable.new("product size ##{ product_size_id } not available")
        end

        size
      end
    end

    # @return ProductColorValue
    def product_color
      @product_color ||= begin

        color_id = product_attributes[:color_id].to_i

        # TODO - Replace all conditionals with just the first `product.product_color_values.active` lookup
        # Once all products are migrated to use explicitly defined ProductColorValues the Fallback else clause can go.
        if (color = product.product_color_values.active.detect { |pcv| color_id == pcv.color_id  })
          # NOOP Handles Database stored recommended and custom colors ProductColorValue
        elsif (color_struct = product_options.colors.extra.detect{ |x| x.id == color_id })
          # Fallback - Handles non-specified Custom colors
          # If a customised colors are available for a product, but no colors are
          # defined as a ProductColorValue, create one on the fly.
          color = ProductColorValue.new.tap do |pcv|
            pcv.product         = product
            pcv.option_value_id = color_struct.id
            pcv.custom          = true
          end
        else
          raise Errors::ProductOptionNotAvailable.new("product color ##{ color_id } not available")
        end

        color
      end
    end

    # Validates if a product has the customization IDs being added
    def product_customizations
      @product_customizations ||= begin
        customizations = []
        Array.wrap(product_attributes[:customizations_ids]).compact.each do |id|
          next if id.blank?
          customization = product.customisation_values.detect { |customisation_value| customisation_value.id == id.to_i }
          if customization.blank?
            raise Errors::ProductOptionNotAvailable.new("product customization ##{ id } not available")
          else
            customizations.push(customization)
          end
        end

        customizations
      end
    end

    def product_making_options
      @product_making_options ||= begin
        product.making_options.where(id: Array.wrap(product_attributes[:making_options_ids])).to_a
      end
    end

    def product_quantity
      product_attributes[:quantity].to_i > 0 ?  product_attributes[:quantity].to_i : 1
    end

    # core/lib/spree/core/controller_helpers/common.rb
    def fire_event(name, extra_payload = {})
      ActiveSupport::Notifications.instrument(name, { order: order })
    end
end
end
