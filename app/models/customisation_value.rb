class CustomisationValue < ActiveRecord::Base
  belongs_to :product,
             class_name: 'Spree::Product'

  has_many :incompatibilities,
           inverse_of: :original,
           foreign_key: :original_id
  has_many :incompatibles,
           through: :incompatibilities,
           dependent: :destroy # without this, 'after_destroy' in Incompatibility wouldn't be called :(

  attr_accessible :position,
                  :name,
                  :presentation,
                  :image,
                  :price,
                  :incompatible_ids

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

  scope :ordered, order('position ASC')

  has_attached_file :image, styles: {
    mini: '48x48>', small: '100x100>', product: '240x240>'#, large: '600x600>'
  }

  before_validation :set_default_position, on: :create

  def set_default_position
    return true if self.position.present? || product.blank?
    if product.present?
      self.position = product.customisation_values.maximum(:position).to_i + 1
    end
  end

  def price
    read_attribute('price').to_f
  end

  def display_price
    Spree::Money.new(price)
  end

  def is_compatible_with?(customisation_value)
    !incompatible_ids.include?(customisation_value.id)
  end
end
