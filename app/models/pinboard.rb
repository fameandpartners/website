class Pinboard < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', inverse_of: :pinboards
  has_many :items, class_name: 'PinboardItem', inverse_of: :pinboard

  attr_accessible :description, :event_date, :name, :purpose

  validates :user, presence: true
  validates_inclusion_of :purpose, in: %w( default wedding )

  def self.weddings
    where(purpose: 'wedding')
  end

  def self.default_or_create
    where(name: 'Wishlist', purpose: 'default').first_or_create
  end

  def add_item(product:, color:, user:, variant: nil)
    product_id = product.id

    pcv = ProductColorValue.where(product_id: product_id, option_value_id: color.id).first

    ev = PinboardItemEvent.creation.new(
      pinboard_id:            self.id,
      product_id:             product_id,
      product_color_value_id: pcv.id,
      color_id:               color.id,
      user_id:                user.id
    )
    ev.variant_id = variant.id if variant.present?
    ev.save!
  end

end
