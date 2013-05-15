class CreateCustomDresses < ActiveRecord::Migration
  def change
    create_table :custom_dresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :description

      t.string :bust
      t.string :waist
      t.string :hips
      t.string :hollow
      t.string :color

      t.timestamps
    end
  end
end
