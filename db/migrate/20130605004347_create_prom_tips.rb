class CreatePromTips < ActiveRecord::Migration
  def change
    create_table :prom_tips do |t|
      t.string :title
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
