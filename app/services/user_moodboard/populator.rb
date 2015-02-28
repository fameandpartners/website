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

  def populate
    if product.present? && color.present?
      add_color_variant(product.id, color.id)
    elsif variant.present?
      add_variant
    else
      raise ArgumentError.new("not enough data to identify color variant")
    end
  end

  private

    def product
      @product ||= begin
        Spree::Product.find(product_id) || variant.product
      end
    end

    def variant
      @variant ||= Spree::Variant.find(variant_id)
    end

    def color
      @color ||= (color_id.present? ? Repositories::ProductColors.read(color_id) : nil)
    end

    def add_color_variant(product_id, color_id)
      item = user.wishlist_items.where(
        spree_product_id: product_id,
        product_color_id: color_id
      ).first_or_initialize
      item.quantity = 1
      item.spree_variant_id = variant.try(:id)
      item.save

      item
    end

    def add_variant
      product_variant = Repositories::ProductVariants.new(product_id: variant.product_id).read(variant.id)

      item = user.wishlist_items.where(
        spree_product_id: variant.product_id,
        product_color_id: product_variant.color_id
      ).first_or_initialize

      item.quantity = 1
      item.spree_variant_id = variant_id

      item
    end
end
