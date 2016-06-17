class UpdateStyleQuizQuestions < ActiveRecord::Migration
  def up
    quiz                    = Quiz.active
    makeup_question         = quiz.questions.where(partial: 'prom_makeup').first
    hair_color_question     = quiz.questions.where(partial: 'hair_colours').first
    questions_weight_change = quiz.questions.includes.order('position ASC').group_by(&:step)

    # Update make up questions answers codes
    [%w(natural boho), %w(romantic girly), %w(dramatic glam), %w(statement classic)].each do |old_code, new_code|
      makeup_question.
        answers.
        where('code LIKE ?', "#{old_code}%").
        update_all("code = replace(code, '#{old_code}', '#{new_code}')")
    end

    # Q 1, 2, 5, 6, 7 Update all image weights to 9
    [1, 2, 5, 6, 7].
      map { |question_index| questions_weight_change[question_index] }.
      map { |questions| questions.map(&:answers) }.
      flatten.
      map { |answer|
      answer.bohemian = 0
      answer.classic  = 0
      answer.girly    = 0
      answer.glam     = 0
      answer.edgy     = 0
      answer.save
      answer
    }.
      map { |answer|

      case answer.code
        when /boho/
          answer.bohemian = 9
        when /classic/
          answer.classic = 9
        when /girly/
          answer.girly = 9
        when /glam/
          answer.glam = 9
        when /edgy/
          answer.edgy = 9
        else
          # NOOP
      end

      answer.save
      answer
    }


    # Remove Auburn Color
    hair_color_question.answers.where(code: 'auburn').destroy_all
  end

  def down
    # NOOP
  end
end
