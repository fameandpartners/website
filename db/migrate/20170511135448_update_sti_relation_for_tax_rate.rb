class UpdateStiRelationForTaxRate < ActiveRecord::Migration
  def up
    Spree::Calculator
      .where(type: 'Taxes::CalifornianCalculator')
      .update_all(type: 'Spree::Calculator::CalifornianTaxRate')
  end

  def down
    Spree::Calculator
      .where(type: 'Spree::Calculator::CalifornianTaxRate')
      .update_all(type: 'Taxes::CalifornianCalculator')
  end
end
