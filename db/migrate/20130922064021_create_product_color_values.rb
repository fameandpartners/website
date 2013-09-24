class CreateProductColorValues < ActiveRecord::Migration
  def change
    create_table :product_color_values do |t|
      t.references :product
      t.references :option_value
    end
  end
end
