class CreateCelebritiesV2 < ActiveRecord::Migration
  def change
    create_table :celebrities do |t|
      t.string :first_name
      t.string :last_name
      t.string :slug

      t.timestamps
    end

    add_index :celebrities, :slug
  end
end
