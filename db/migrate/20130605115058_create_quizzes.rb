class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes, force: true do |t|
      t.string :name

      t.timestamps
    end
  end
end
