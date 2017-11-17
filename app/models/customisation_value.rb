class CustomisationValue < ActiveRecord::Base
  AVAILABLE_CUSTOMISATION_TYPES = %w(cut fabric length fit style)
  AVAILABLE_POINTS_OF_VIEW = %w(front back)

  belongs_to :product,
             class_name: 'Spree::Product'
  has_many :incompatibilities,
           inverse_of: :original,
           foreign_key: :original_id
  has_many :incompatibles,
           through: :incompatibilities,
           dependent: :destroy # without this, 'after_destroy' in Incompatibility wouldn't be called :(
  has_many :discounts, as: :discountable

  attr_accessible :position,
                  :name,
                  :presentation,
                  :image,
                  :price,
                  :incompatible_ids,
                  :customisation_type

  validates :name,
            presence: true,
            uniqueness: {
              scope: :product_id,
              case_sensitive: false
            }
  validates :presentation,
            presence: true,
            uniqueness: {
              scope: :product_id,
              case_sensitive: false
            }
  validates :price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }
  validates :position,
            presence: true,
            numericality: {
              only_integer: true
            },
            uniqueness: {
              scope: :product_id
            }
  validates :customisation_type,
            presence: true,
            inclusion: { in: AVAILABLE_CUSTOMISATION_TYPES }

  scope :ordered, order('position ASC')
  scope :by_type, lambda { |customisation_type| where(customisation_type: customisation_type) }

  has_attached_file :image, styles: {
    mini: '48x48>', small: '100x100>', product: '240x240>'#, large: '600x600>'
  }

  before_validation :set_default_position, on: :create

  def set_default_position
    return true if self.position.present? || product.blank? 
    if product.present?
      self.position = JSON.parse(product.customizations, object_class: OpenStruct).maximum(:position).to_i + 1 #TODO: Test this out as well think the logic is off
    end
  end

  def price
    read_attribute('price')
  end

  def display_price
    if discount.blank? || discount.amount.to_i == 0
      Spree::Money.new(price)
    else
      Spree::Price.new(amount: self.price).apply(self.discount).display_price
    end
  end

  def is_compatible_with?(customisation_value)
    !incompatible_ids.include?(customisation_value.id)
  end

  def discount
    return @discount if instance_variable_defined?('@discount')
    @discount = Repositories::Discount.read(self.class, self.id)
  end
end
