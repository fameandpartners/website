class MoodboardItem < ActiveRecord::Base
  has_many :events,
    class_name: 'MoodboardItemEvent',
    foreign_key: 'moodboard_item_uuid',
    primary_key: 'uuid'

  belongs_to :moodboard, inverse_of: :items
  belongs_to :product_color_value, class_name: 'ProductColorValue'
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :color,   class_name: 'Spree::OptionValue'
  belongs_to :variant, class_name: 'Spree::Variant'
  belongs_to :user,    class_name: 'Spree::User'
  has_many :moodboard_comments

  attr_accessible :uuid, :comments, :likes, :user_id, :moodboard_id, :product_id, :product_color_value_id, :color_id

  validates :uuid, uniqueness: true, presence: true

  scope :active, -> { where(deleted_at: nil) }
  def active?
    ! deleted_at.present?
  end
end
