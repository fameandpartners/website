class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question
      t.string :code
      t.float :glam
      t.float :girly
      t.float :classic
      t.float :edgy
      t.float :bohemian
      t.float :sexiness
      t.float :fashionability

      t.timestamps
    end

    add_index :answers, :question_id
  end
end
