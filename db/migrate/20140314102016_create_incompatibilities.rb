class CreateIncompatibilities < ActiveRecord::Migration
  def change
    create_table :incompatibilities do |t|
      t.integer :original_id
      t.integer :incompatible_id
    end

    add_index :incompatibilities, :original_id
    add_index :incompatibilities, :incompatible_id
  end
end
