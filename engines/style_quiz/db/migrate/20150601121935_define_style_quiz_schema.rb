class DefineStyleQuizSchema < ActiveRecord::Migration
  def change
    create_table :style_quiz_questions, force: true do |t|
      t.string  :code
      t.string  :name
      t.string  :partial
      t.integer :position
    end

    create_table :style_quiz_answers, force: true do |t|
      t.references :question
      t.string  :group
      t.string  :name
      t.string  :value
      t.string  :image
      t.integer :position
    end

    create_table :style_quiz_answer_tags, force: true do |t|
      t.references :answer
      t.references :tag
    end

    create_table :style_quiz_tags, force: true do |t|
      t.string :group
      t.string :name
    end
  end
end
