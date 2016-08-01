class CreateWeddingStyleQuiz < ActiveRecord::Migration
  def up
    if (old_quiz = Quiz.where(name: 'Style Quiz').last)
      wedding_quiz = Quiz.create!(name: 'Wedding Quiz')

      old_quiz.questions.each do |old_question|
        new_question      = old_question.dup
        new_question.quiz = wedding_quiz
        new_question.save!

        old_question.answers.each do |old_answer|
          new_answer          = old_answer.dup
          new_answer.question = new_question

          new_answer.save!
        end
      end
    end
  end

  def down
    if (wedding_quiz = Quiz.where(name: 'Wedding Quiz').last)
      wedding_quiz.destroy
    end
  end
end
