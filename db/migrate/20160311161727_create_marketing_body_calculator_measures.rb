class CreateMarketingBodyCalculatorMeasures < ActiveRecord::Migration
  def change
    create_table :marketing_body_calculator_measures do |t|
      t.string :email
      t.string :shape
      t.string :size
      t.float :bust_circumference, default: 0.0
      t.float :under_bust_circumference, default: 0.0
      t.float :waist_circumference, default: 0.0
      t.float :hip_circumference, default: 0.0

      t.timestamps
    end
  end
end
