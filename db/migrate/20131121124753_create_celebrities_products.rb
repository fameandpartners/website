class CreateCelebritiesProducts < ActiveRecord::Migration
  def change
    create_table :celebrities_products, primary: false do |t|
      t.integer :celebrity_id
      t.integer :product_id
    end

    add_index :celebrities_products, :celebrity_id
  end
end
