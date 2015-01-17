# Usage:
#   @discount ||= Repositories::Discount.read(self.class, self.id)
#   @discounts ||= Repositories::Discount.read_all(self.class, [])

module Repositories; end
class Repositories::Discount
  def self.read(discountable_class, discountable_id)
    read_all(discountable_class, discountable_id).first
  end

  def self.read_all(discountable_class, discountable_ids)
    sales_ids = active_sales_ids
    return [] if sales_ids.blank?

    scope = search_scope(
      discountable_type: discountable_class.to_s,
      discountable_id: discountable_ids,
      sale_id: sales_ids
    )

    result = []
    scope.group_by{|discount| discount.discountable_id}.each do |id, discounts|
      result.push(discounts.max_by(&:amount))
    end
    result
  end

  private

    def self.active_sales_ids
      Spree::Sale.active_sales_ids
    end

    def self.search_scope(options = {})
      ::Discount.where(options).where("amount is not null and amount > 0").order('amount desc')
    end
end
