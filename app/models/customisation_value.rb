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

  validates :price_aud,
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

    self.position = (product.customisation_values.maximum(:position) || 0) + 10
  end

  def price_in(currency)
    if currency.downcase == 'aud'
      return self.price_aud || self.price
    else
      return self.price
    end
  end

  def discount_price_in(currency)
    Spree::Price.new(amount: price_in(currency)).apply(discount).price
  end

  def discount
    @discount ||= product.discount #discounts.active.first
  end
end
