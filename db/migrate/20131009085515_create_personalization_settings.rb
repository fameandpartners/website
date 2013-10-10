class CreatePersonalizationSettings < ActiveRecord::Migration
  def change
    create_table :personalization_settings do |t|
      t.integer :user_id
      t.integer :size
      t.integer :height
      t.integer :body_shape_id

      t.timestamps
    end
  end
end
