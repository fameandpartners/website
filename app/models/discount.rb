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

  validates_presence_of :discountable_type, :discountable_id
  validates :discountable_id, uniqueness: { scope: [:discountable_type, :sale_id] }

  validates :sale_id, presence: true

  scope :for_products, where(discountable_type: "Spree::Product")

  scope :active, -> {
    joins(:sale).where(spree_sales: {is_active: true})
  }

  def size
    (amount.presence || sale&.discount_size.presence).to_f
  end
end
