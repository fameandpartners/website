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
    add_personalized_product

    order.update!
    order.reload

    return OpenStruct.new({
      success: true,
    })
  rescue Errors::ProductOptionsNotCompatible, Errors::ProductOptionNotAvailable => e
    OpenStruct.new({ success: false, message: e.message })
  end

  private
    def add_product_to_cart
      spree_populator = Spree::OrderPopulator.new(order, currency)
      if spree_populator.populate(variants: { product_variant.id => product_quantity })

        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')
        true
      else
        false
      end
    end

    def add_personalized_product
      ActiveRecord::Base.transaction do
        add_product_to_cart
        add_making_options

        line_item.customizations =  price_customization_by_currency(product_customizations).to_json
        if product_fabric
          line_item.fabric = product_fabric
          fp = FabricsProduct.find_by_fabric_id_and_product_id(product_fabric.id, product.id)
          line_item.fabric_price = fp&.discount_price_in(currency) 
        end
        line_item.curation_name = product_attributes[:curation_name]
        line_item.personalization = build_personalization(line_item)
        line_item.save!
      end
    end

    def add_making_options
      line_item.making_options = product_making_options.collect do |making_option|
        LineItemMakingOption.build_option(making_option, currency)
      end
    end

    def build_personalization(line_item)
      LineItemPersonalization.new.tap do |item|
        item.size_id  = product_size&.id
        item['size']  = product_size&.value
        
        if product_fabric
          item.color_id = product_fabric.option_value_id
          item['color'] = product_fabric.option_value.name
        else
          item.color_id = product_color.color_id
          item['color'] = product_color.color_name
        end
        item.product_id = product.id
        item.line_item = line_item

        if product_attributes[:height].present?
          item.height = product_attributes[:height]
        else
          item.height_value = product_attributes[:height_value]
          item.height_unit = product_attributes[:height_unit]
          item.height = StyleToProductHeightRangeGroup.map_height_values_to_height_name( product_variant, product_attributes[:height_value], product_attributes[:height_unit] )
        end
      end
    end


    def product
      @product ||= product_variant.product
    end

    def product_variant
      @variant ||= begin
        variant = Spree::Variant.where(id: product_attributes[:variant_id]).first

        unless variant
          variant = Spree::Variant.find_by_sku(product_attributes[:variant_id])
        end

        variant
      end
    end

    def product_fabric
      if !product_attributes[:fabric_id].blank?
        @fabric ||= Fabric.joins(:products).where('spree_products.id = ? and (fabrics.id = ? or fabrics.name = ?)', product.id, product_attributes[:fabric_id].to_i, product_attributes[:fabric_id].to_s).first
      else
        nil
      end
    end

    def line_item
      # Sorted by created at to ensure it is the last created line item
      @line_item ||= Spree::LineItem.where(order_id: order.id, variant_id: product_variant.id).order('created_at desc').first
    end

    def product_size
      @product_size ||= begin
        product_size_id = product_attributes[:size_id]

        sizes = product.option_types.find_by_name('dress-size')&.option_values || []
        size = sizes.find {|size| size.id == product_size_id.to_i || size.name == product_size_id}


        if size.present?
          # nothing
        elsif sizes.empty?
          # nothing
        else
          raise Errors::ProductOptionNotAvailable.new("product size ##{ product_size_id } not available")
        end

        size
      end
    end

    # @return ProductColorValue
    def product_color
      @product_color ||= begin

        if product_fabric
          color_id = product_fabric.option_value_id
        else
          color_id = product_attributes[:color_id].to_i
        end

        # TODO - Replace all conditionals with just the first `product.product_color_values.active` lookup
        # Once all products are migrated to use explicitly defined ProductColorValues the Fallback else clause can go.
        if (color = product.product_color_values.active.detect { |pcv| color_id == pcv.color_id  })
          # NOOP Handles Database stored recommended and custom colors ProductColorValue
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
          customization = product.customisation_values.detect { |customisation_value| customisation_value.id.to_s == id.to_s || customisation_value.name.to_s == id }
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
      pmo = product.making_options.where(id: Array.wrap(product_attributes[:making_options_ids])).to_a
      if product.name == 'Swatch'
        pmo = product.making_options.where(default: true, active: true).to_a if pmo.empty?
      else
        pmo = product.making_options.where(making_option_id: [4,12,15], active: true).to_a if pmo.empty?
      end

      pmo
    end
  end

    def product_quantity
      product_attributes[:quantity].to_i > 0 ?  product_attributes[:quantity].to_i : 1
    end

    # core/lib/spree/core/controller_helpers/common.rb
    def fire_event(name, extra_payload = {})
      ActiveSupport::Notifications.instrument(name, { order: order })
    end

    def price_customization_by_currency(customizations_json)
      customization_arry = customizations_json.map do |customization|

          {
            'customisation_value' => {
              'id' => customization.id,
              'name' => customization.name,
              'manifacturing_sort_order' => customization.manifacturing_sort_order,
              'price' => customization.price_aud && currency == 'AUD' ? customization.price_aud : customization.price,
              'presentation' => customization.presentation,
              'discount' => customization.discount&.amount
            }
          }

      end

      customization_arry
    end

end
end
