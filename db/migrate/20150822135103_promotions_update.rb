class PromotionsUpdate < ActiveRecord::Migration
  def up
    add_column Spree::Promotion.table_name, :eligible_to_custom_order,  :boolean, default: false
    add_column Spree::Promotion.table_name, :eligible_to_sale_order,    :boolean, default: false
    add_column Spree::Promotion.table_name, :require_shipping_charge,   :boolean, default: false

    set_eligible_to_sale_order_value
    set_eligible_to_custom_order_value
    set_shipping_charge
  end

  def down
    remove_column Spree::Promotion.table_name, :eligible_to_custom_order
    remove_column Spree::Promotion.table_name, :eligible_to_sale_order
    remove_column Spree::Promotion.table_name, :require_shipping_charge
  end

  private

  def eligible_to_sale_order_promos
    %w(xtra10 swm30 is20 who20 fam20 btb20p btb20d gf20 theparcel25 frenzy5p crafted4u vosn2015 famer35p zouponsfame famexinstyle5 ibotta5 famexAU5 famexUS5 bonus5p birthday5p famexsale5 famexhuffington5 fashionitgirlsale5)
  end

  def set_eligible_to_sale_order_value
     Spree::Promotion.where(
       "code ilike any(array[?])", eligible_to_sale_order_promos
     ).update_all(eligible_to_sale_order: true)
  end

  def set_eligible_to_custom_order_value
    Spree::Promotion.update_all(eligible_to_custom_order: false)

    Spree::Promotion.find_each(batch_size: 100) do |promotion|
      calculators = promotion.actions
                      .select {|a| a.respond_to?(:calculator)}
                      .map{|action| action.calculator.try(:type) }.compact.uniq
      if calculators.include?('Spree::Calculator::PersonalizationDiscount')
        promotion.update_column(:eligible_to_custom_order, true)
      end
    end
  end

  def set_shipping_charge
    Spree::Promotion.update_all(require_shipping_charge: false)
  end
end
