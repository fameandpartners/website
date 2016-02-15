class CreateSimpleKeyValues < ActiveRecord::Migration
  def change
    create_table :simple_key_values do |t|
      t.string :key, null: false
      t.text :data

      t.timestamps
    end
  end
end
