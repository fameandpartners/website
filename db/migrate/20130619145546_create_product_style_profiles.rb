class CreateProductStyleProfiles < ActiveRecord::Migration
  def change
    create_table :product_style_profiles do |t|
      t.references :product

      # styles
      t.integer :glam
      t.integer :girly
      t.integer :classic
      t.integer :edgy
      t.integer :bohemian

      # body shapes
      t.integer :apple
      t.integer :pear
      t.integer :strawberry
      t.integer :hour_glass
      t.integer :column

      # bra sizes
      t.integer :bra_aaa
      t.integer :bra_aa
      t.integer :bra_a
      t.integer :bra_b
      t.integer :bra_c
      t.integer :bra_d
      t.integer :bra_e
      t.integer :bra_fpp

      t.integer :sexiness
      t.integer :fashionability

      t.timestamps
    end
    add_index :product_style_profiles, :product_id
  end
end
