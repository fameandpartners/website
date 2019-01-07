class ProductColorValue < ActiveRecord::Base
  attr_accessible :option_value, :product, :product_id, :option_value_id, :active, :custom

  belongs_to :product, class_name: 'Spree::Product', inverse_of: :product_color_values

  # TODO: this relationship uses a deprecated option: `conditions`. This should be a simple validation or anything else! This will not work on Rails 4!
  # TODO: when removing this `conditions` options, REMEMBER to remove it from the "spec/support/memoization_support.rb" file
  belongs_to :option_value,
             class_name: 'Spree::OptionValue',
             conditions: ['option_type_id = ?', Spree::OptionType.color_scope ]

  has_many :images, as: :viewable, order: :position, dependent: :destroy, class_name: "Spree::Image"

  validates :product_id, :option_value_id, presence: true

  def recommended?
    ! custom?
  end

  def indexable?
    images.any?
  end

  def color_name
    option_value.name
  end

  def color_id
    option_value_id
  end

  def self.active
    where(active: true)
  end

  def self.recommended
    where(custom: false)
  end

  def self.custom
    where(custom: true)
  end
end
