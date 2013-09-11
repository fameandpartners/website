class ProductStyleProfile < ActiveRecord::Base
  BODY_SHAPES = %W{apple pear athletic strawberry hour_glass column petite}
  BASIC_STYLES = %w(glam girly classic edgy bohemian)
  BRA_SIZES = %w(bra_aaa bra_aa bra_a bra_b bra_c bra_d bra_e bra_fpp)
  
  default_values Hash[ *BASIC_STYLES.collect{|t| [t, 0]}.flatten]
  default_values Hash[ *BODY_SHAPES.collect{|t| [t, 0]}.flatten]
  default_values Hash[ *BRA_SIZES.collect{|t| [t, 0]}.flatten]

  default_values :sexiness => 0, :fashionability => 0

  attr_accessible *BASIC_STYLES
  attr_accessible *BODY_SHAPES
  attr_accessible *BRA_SIZES
  attr_accessible :sexiness, :fashionability

  numericality = { 
    :allow_blank => true,
    :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 10
  }
  validates *BASIC_STYLES, numericality: numericality
  validates *BODY_SHAPES, numericality: numericality
  validates *BRA_SIZES, numericality: numericality
  validates :sexiness, :fashionability, numericality: numericality
#  validate do
#    unless attributes.slice(*BASIC_STYLES).values.sum.eql?(10)
#      errors.add(:base, :"points_number.invalid")
#    end
#  end

  belongs_to :product,
             :class_name => 'Spree::Product'

  after_update do
    product.try(:update_index)
  end

  def suitable_shapes
    ProductStyleProfile::BODY_SHAPES.select do |shape|
      attributes[shape].to_i > 0
    end
  end
end
