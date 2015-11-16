# usage
#  UserMoodboard::Populator.new(
#    user: user, # mandatory
#    variant_id: '', # if not provided, than product & color_id should present
#    product_id: '',
#    color_id: '',
#  ).populate
#
#  not all 
#
module UserMoodboard; end
class UserMoodboard::Populator
  attr_reader :user, :product_id, :variant_id, :color_id

  def initialize(options = {})
    @user       = options[:user]
    @product_id = options[:product_id]
    @variant_id = options[:variant_id]
    @color_id   = options[:color_id]
  end

  # cases priority
  # product + color
  # variant [ it can be master variant, so no color data ]
  # product
  def populate
    validate!

    if color.present?
      add_color_variant(product, variant, color)
    elsif variant.present?
      add_variant(variant)
    else
      add_variant(product.master)
    end
  end

  def validate!
    if product.blank? && variant.blank?
      raise ArgumentError.new("not enough data to identify product")
    end
  end

  private

    def product
      @product ||= (product_id.present? ? Spree::Product.where(id: product_id).first : nil)
    end

    def variant
      @variant ||= (variant_id.present? ? Spree::Variant.find(variant_id) : nil)
    end

    def color
      @color ||= (color_id.present? ? Repositories::ProductColors.read(color_id) : nil)
    end

    def add_color_variant(product, variant, color)
      binding.pry if variant

      product_id = product.try(:id) || variant.product_id
      variant_id = variant.try(:id)
      item = user.wishlist_items.where(
        spree_product_id: product.try(:id) || variant.product_id,
        product_color_id: color_id
      ).first_or_initialize
      item.quantity = 1
      item.spree_variant_id = variant.try(:id) || product.master.id
      # item.save
# binding.pry


# pcv = ProductColorValue.where(product_id: product_id, option_value_id: color_id).first
      # ProductColorValue.where(product_id: product_id, option_value_id: color_id)

      user.pinboards.default_or_create.add_item(product: product, color: color, user: user, variant: variant)
      # pinboard = user.pinboards.default_or_create
      # # binding.pry
      # ev = PinboardItemEvent.creation.new(
      #   pinboard_id:            pinboard.id,
      #   product_id:             product_id,
      #   product_color_value_id: pcv.id,
      #   color_id:               color_id,
      #   user_id:                user.id
      # )
      # ev.save!
      # binding.pry
      #
      # user.pinboards.default_or_create.items.events.creation.create(
      #
      #   product_id: product_id,
      #   product_color_value_id: pcv.id,
      #   color_id: color_id,
      #   # variant_id: variant_id,
      #   user_id: user.id
      # )

      item
    end

    def add_variant(variant)
      product_variant = Repositories::ProductVariants.new(product_id: variant.product_id).read(variant.id)

      item = user.wishlist_items.where(
        spree_product_id: variant.product_id,
        product_color_id: product_variant.try(:color_id)
      ).first_or_initialize

      binding.pry
      user.pinboards.default_or_create.items.where(product_id: variant.product_id, variant_id: variant.id).first_or_create

      item.quantity = 1
      item.spree_variant_id = variant.id

      item.save
      item
    end
end
