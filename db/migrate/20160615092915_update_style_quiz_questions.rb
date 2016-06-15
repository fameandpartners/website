class UpdateStyleQuizQuestions < ActiveRecord::Migration
  def up
    quiz                = Quiz.active
    makeup_question     = quiz.questions.where(partial: 'prom_makeup').first
    hair_color_question = quiz.questions.where(partial: 'hair_colours').first

    # Update make up questions answers codes
    [%w(natural boho), %w(romantic girly), %w(dramatic glam), %w(statement classic)].each do |old_code, new_code|
      makeup_question.
        answers.
        where('code LIKE ?', "#{old_code}%").
        update_all("code = replace(code, '#{old_code}', '#{new_code}')")
    end

    # Q 1, 2, 5, 6, 7 Update all image weights to 9
    # TODO: question to Radek

    # Remove Auburn Color
    hair_color_question.answers.where(code: 'auburn').destroy_all
  end

  def down
    # NOOP
  end
end
