class CreateCelebrityStyleProfiles < ActiveRecord::Migration
  def change
    create_table :celebrity_style_profiles do |t|
      t.integer :celebrity_id
      t.integer :glam
      t.integer :girly
      t.integer :classic
      t.integer :edgy
      t.integer :bohemian
      t.text :description

      t.timestamps
    end

    add_index :celebrity_style_profiles, :celebrity_id
  end
end
