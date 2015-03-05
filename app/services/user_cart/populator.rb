# reason to extract - old line_items#create is overgrown. and not manageable
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
#        quantity: 1
#      }
#    )
module UserCart; end
class  UserCart::Populator
  attr_reader :site_version, :order, :currency, :product_attributes

  def initialize(options = {})
    @order            = options[:order]
    @site_version     = options[:site_version] || SiteVersion.default
    @currency         = options[:currency]  || site_version.try(:currency)
    @product_attributes = HashWithIndifferentAccess.new(options[:product] || {})
  end

  def populate
    if personalized_product?
      add_personalized_product
    else
      add_product_to_cart
    end

    order.update!
    order.reload

    return OpenStruct.new({
      success: false,
      product: product,
      cart_product: Repositories::CartProduct.new(line_item: line_item).read
    })
  #rescue
  #  return OpenStruct.new({ success: false })
  end

  private

    def add_product_to_cart(ignore_stock_level = false)
      spree_populator = Spree::OrderPopulator.new(order, currency)

      if ignore_stock_level
        spree_populator.populate_personalized = ignore_stock_level
      end

      if spree_populator.populate(variants: { product_variant.id => product_quantity })
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
        if line_item.blank? # user already have customized dress [ we can't have more than one personalization per dress ]
          add_product_to_cart(ignore_stock_level = true)
        end

        if line_item.present?
          line_item.personalization.try(:destroy)
          personalization.line_item = line_item
          personalization.save
        end
      end

      true
    end

    def build_personalization
      LineItemPersonalization.new.tap do |item|
        item.size     = product_size.name
        item.size_id  = product_size.id
        item['color'] = product_color.name
        item.color_id = product_color.id
        item.customization_value_ids = product_customizations.map(&:id)
        item.product_id = product.id
      end
    end

    def personalized_product?
      product_variant.is_master? || product_color.custom || product_size.custom || product_customizations.present?
    end

    def product
      @product ||= product_variant.product
    end

    def product_variant
      @variant ||= Spree::Variant.where(id: product_attributes[:variant_id]).first
    end

    def line_item
      @line_item ||= Spree::LineItem.where(order_id: order.id, variant_id: product_variant.id).first
    end

    def product_options
      @product_options = Products::SelectionOptions.new(site_version: site_version, product: product).read
    end

    def product_size
      @product_size ||= begin
        size = product_options.sizes.default.detect{|size| size.id == product_attributes[:size_id].to_i}
        if size.present?
          size.custom = false
        else
          size = product_options.sizes.extra.detect{|size| size.id == product_attributes[:size_id].to_i}
          size.custom = true
        end

        size
      end
    end

    def product_color
      @product_color ||= begin
        color = product_options.colors.default.detect{|color| color.id == product_attributes[:color_id].to_i}
        if color.present?
          color.custom = false
        else
          color = product_options.colors.extra.detect{|color| color.id == product_attributes[:color_id].to_i}
          color.custom = true
        end

        color
      end
    end

    def product_customizations
      @product_customizations ||= begin
        (product_attributes[:customizations] || []).collect do |id|
          product_options.customizations.all.detect{|item| item.id == id}
        end.compact
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
