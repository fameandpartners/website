class Discount < ActiveRecord::Base
  belongs_to :variant, class_name: 'Spree::Variant'
  belongs_to :color, class_name: 'Spree::OptionValue'
  belongs_to :customization, class_name: 'CustomisationValue'

  attr_accessible :amount

  validates :amount,
            presence: true,
            numericality: {
              allow_blank: true,
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 0
            }
end
