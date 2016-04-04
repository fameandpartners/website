class AddUnitsToMarketingBodyCalculatorMeasures < ActiveRecord::Migration
  def change
    add_column :marketing_body_calculator_measures, :unit, :string
  end
end
