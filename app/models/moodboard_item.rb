class MoodboardItem < ActiveRecord::Base
  belongs_to :moodboard, inverse_of: :items
  belongs_to :product_color_value, class_name: 'ProductColorValue'
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :color,   class_name: 'Spree::OptionValue'
  belongs_to :variant, class_name: 'Spree::Variant'
  belongs_to :user,    class_name: 'Spree::User'

  attr_accessible :uuid, :comments, :likes

  validates :uuid, uniqueness: true, presence: true
end
