class ProductColorValue < ActiveRecord::Base
  attr_accessible :option_value

  belongs_to :product, class_name: 'Spree::Product', inverse_of: :product_color_values
  belongs_to :option_value,
             class_name: 'Spree::OptionValue',
             conditions: ['option_type_id = ?', Spree::OptionType.color_scope ]

  has_many :images, as: :viewable, order: :position, dependent: :destroy, class_name: "Spree::Image"

  def recommended?
    ! custom?
  end

  def indexable?
    images.any?
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
