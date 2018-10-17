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

  def initialize(user:, product_id:, color_id:, variant_id: nil, moodboard: nil)
    @user       = user
    @product_id = product_id
    @variant_id = variant_id
    @color_id   = color_id
    @moodboard  = moodboard
  end

  def moodboard
    @moodboard ||= user.moodboards.default_or_create
  end

  # cases priority
  # product + color
  # variant [ it can be master variant, so no color data ]
  # product
  def populate
    validate!

    if color.present?
      add_color_variant(product: product, variant: variant, color: color)
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

    def add_color_variant(product:, variant:, color:)
      moodboard.add_item(product: product, color: color, user: user, variant: variant)
    end

    def add_variant(variant)
      product_variant = Repositories::ProductVariants.new(product_id: variant.product_id).read(variant)
      NewRelic::Agent.notice_error('UNEXPECTED USE OF UserMoodboard::Populator#add_variant')

      item = user.wishlist_items.where(
        spree_product_id: variant.product_id,
        product_color_id: product_variant.try(:color_id)
      ).first_or_initialize

      item.quantity = 1
      item.spree_variant_id = variant.id

      item.save
      item
    end
end
