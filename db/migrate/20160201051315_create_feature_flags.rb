class CreateFeatureFlags < ActiveRecord::Migration
  def change
    create_table :feature_flags do |t|
      t.string :key, null: false
      t.text :data

      t.timestamps
    end
  end
end
