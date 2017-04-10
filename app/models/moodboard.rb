class Moodboard < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', inverse_of: :moodboards
  has_many :items, class_name: 'MoodboardItem', inverse_of: :moodboard
  has_many :collaborators, class_name: 'MoodboardCollaborator', inverse_of: :moodboard

  attr_accessible :description, :event_date, :name, :purpose, :event_progress, :owner_relationship, :guest_count, :bride_first_name, :bride_last_name

  validates :user, presence: true
  validates :name, presence: true
  validates_inclusion_of :purpose, in: %w( default wedding )

  scope :weddings, -> { where(purpose: 'wedding') }
  scope :by_recent, -> { order('created_at asc') }

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

  # TODO ? Promote into a service?
  def add_item(product:, color:, user:, variant: nil)
    product_id = product.id
    color_id   = color[:id]

    return unless user_member?(user)
    return if items.active.where(product_id: product_id, color_id: color_id ).exists?

    pcv_id = ProductColorValue.where(product_id: product_id, option_value_id: color_id).first.try(:id)

    ev = MoodboardItemEvent.creation.new(
      moodboard_id:           self.id,
      product_id:             product_id,
      product_color_value_id: pcv_id,
      color_id:               color[:id],
      user_id:                user.id
    )
    ev.variant_id = variant.id if variant.present?

    ev.save!
  end

  def user_member?(candidate_user)
    collaborators.map(&:user_id).compact.include?(candidate_user.id) || self.user_id == candidate_user.id
  end

  def allow_comments?
    purpose == 'wedding'
  end
end
