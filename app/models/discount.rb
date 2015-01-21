class Discount < ActiveRecord::Base
  belongs_to :sale, class_name: 'Spree::Sale', foreign_key: :sale_id
  belongs_to :discountable, polymorphic: true

  attr_accessible :amount,
                  :discountable_type,
                  :discountable_id,
                  :sale_id

  validates :amount,
            numericality: {
              allow_blank: true,
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }

  validates :sale_id, presence: true

  scope :for_products, where(discountable_type: "Spree::Product")

  def size
    if amount.present?
      amount
    elsif sale.present?
      sale.discount_size
    else
      0
    end
  end
end
