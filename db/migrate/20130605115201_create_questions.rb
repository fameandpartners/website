class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions, force: true do |t|
      t.references :quiz
      t.string :text
      t.string :position
      t.string :partial
      t.boolean :multiple, :default => false

      t.timestamps
    end
    add_index :questions, :quiz_id
    add_index :questions, :position
  end
end
