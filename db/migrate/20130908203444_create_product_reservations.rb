class CreateProductReservations < ActiveRecord::Migration
  def change
    create_table :product_reservations do |t|
      t.references :user
      t.references :product

      t.string :school_name
      t.string :formal_name
      t.string :school_year
      t.string :color

      t.timestamps
    end
  end
end
