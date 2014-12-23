class Discount < ActiveRecord::Base
  belongs_to :sale, class_name: 'Spree::Sale'
  belongs_to :discountable, polymorphic: true

  attr_accessible :amount,
                  :discountable_type,
                  :discountable_id

  belongs_to :discountable, polymorphic: true
  belongs_to :sale, class_name: 'Spree::Sale'

  validates :amount,
            numericality: {
              allow_blank: true,
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }
end
