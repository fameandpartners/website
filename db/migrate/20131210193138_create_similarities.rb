class CreateSimilarities < ActiveRecord::Migration
  def change
    create_table :similarities do |t|
      t.integer :original_id
      t.integer :similar_id
    end

    add_index :similarities, :original_id
    add_index :similarities, :similar_id
  end
end
