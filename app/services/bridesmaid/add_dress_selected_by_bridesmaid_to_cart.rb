# TODO:
# instead make changes, please, split this service to
#   - order/add_plain_product_variant_to_cart
#   - order/add_customized_product_variant_to_cart
# and this service should just call required
#
class Bridesmaid::AddDressSelectedByBridesmaidToCart
  attr_reader :site_version, :accessor, :cart, :membership_id, :promotion

  def initialize(options = {})
    @site_version   ||= options[:site_version]
    @accessor       ||= options[:accessor]
    @cart           ||= options[:cart]
    @membership_id  ||= options[:membership_id]
    @promotion      ||= options[:promotion]
  end

  def process
    if customized_item?
      add_product_to_cart_with_personalization
    else
      add_product_to_cart
    end

    apply_promotion if promotion.present?

    cart.update!
    cart.reload

    OpenStruct.new({
      name: product.name,
      sku: product.sku,
      price: product.price
    })
  end

  private

    def default_notification_payload
      { user: accessor, order: cart }
    end

    def fire_event(name, extra_payload = {})
      ActiveSupport::Notifications.instrument(name, default_notification_payload.merge(extra_payload))
    end

    def currency
      site_version.currency || cart.currency
    end

    def membership
      @membership ||= BridesmaidParty::Member.find(membership_id)
    end

    def variant
      @variant ||= Spree::Variant.find(membership.variant_id)
    end

    def product
      variant.product
    end

    def color
      @color = (Spree::OptionValue.where(id: membership.color_id).first || variant.dress_color)
    end

    def size
      @color = (Spree::OptionValue.where(id: membership.size).first || variant.dress_size)
    end

    def customized_item?
      return @is_item_customized if instance_variable_defined?('@is_item_customized')
      @is_item_customized = variant.is_master? || membership.customization_value_ids.present? || variant.dress_color.blank?  || variant.dress_size.blank?
      @is_item_customized
    end

    def add_product_to_cart
      quantity = 1
      populator = Spree::OrderPopulator.new(cart, currency)

      populator.populate(variants: { variant.id => quantity })

      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')
    end
    
    def add_product_to_cart_with_personalization
      quantity = 1
      variant_id = product.master.id

      personalization = LineItemPersonalization.new()
      #personalization.product_id = product.id
      #personalization.color = color.name
      personalization.color_id = color.id
      personalization.size_id  = size.try(:id)
      personalization.customization_value_ids = membership.customization_value_ids
      #personalization.price = product.price

      if personalization.valid?
        populator = Spree::OrderPopulator.new(cart, currency)
        populator.populate_personalized = true

        line_item = Spree::LineItem.where(order_id: cart.id, variant_id: variant_id).first
        if line_item.blank? && populator.populate(variants: { variant_id => quantity })
          fire_event('spree.cart.add')
          fire_event('spree.order.contents_changed')
        end
      else
        raise 'invalid selected dress personalization'
      end

      line_item = Spree::LineItem.where(order_id: cart.id, variant_id: variant_id).first
      if line_item.present? && personalization.valid?
        line_item.personalization.try(:destroy)
        personalization.line_item = line_item
        personalization.save
      end
    end

    def apply_promotion
      Bridesmaid::OrderPromotionUpdater.new(
        accessor: accessor,
        promotion: promotion,
        order: cart
      ).process
    end
end
