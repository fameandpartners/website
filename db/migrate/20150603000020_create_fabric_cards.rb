class CreateFabricCards < ActiveRecord::Migration
  def change
    create_table :fabric_cards do |t|
      t.text :name, null: false
      t.text :code, index: { unique: true }
      t.text :name_zh
      t.text :description

      t.timestamps
    end

    create_table :fabric_colours do |t|
      t.text :name
      t.references :dress_colour

      t.timestamps
    end

    create_table :fabric_card_colours do |t|
      t.text :position
      t.text :code
      t.references :fabric_colour
      t.references :fabric_card

      t.timestamps
    end
    add_index :fabric_card_colours, :fabric_colour_id
    add_index :fabric_card_colours, :fabric_card_id
  end
end
