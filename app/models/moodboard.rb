class Moodboard < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', inverse_of: :moodboards
  has_many :items, class_name: 'MoodboardItem', inverse_of: :moodboard

  attr_accessible :description, :event_date, :name, :purpose

  validates :user, presence: true
  validates_inclusion_of :purpose, in: %w( default wedding )

  scope :weddings, -> { where(purpose: 'wedding') }

  # Intended for use as a chained scope off of a Spree::User object.
  # e.g. user.moodboards.default_or_create
  def self.default_or_create
    where(default_wishlist_attrs).first_or_create
  end

  def self.default_wishlist_attrs
    {name: 'Wishlist', purpose: 'default'}
  end

  def default?
    defaults = self.class.default_wishlist_attrs
    name == defaults[:name] && purpose == defaults[:purpose]
  end

  def add_item(product:, color:, user:, variant: nil)
    product_id = product.id

    pcv = ProductColorValue.where(product_id: product_id, option_value_id: color.id).first

    ev = MoodboardItemEvent.creation.new(
      moodboard_id:           self.id,
      product_id:             product_id,
      product_color_value_id: pcv.id,
      color_id:               color.id,
      user_id:                user.id
    )
    ev.variant_id = variant.id if variant.present?

    ev.save!
  end
end
