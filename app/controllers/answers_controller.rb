class AnswersController < ApplicationController
  before_filter :authenticate_spree_user!

  layout nil

  def create
    quiz = Quiz.first
    question = quiz.questions.find(session['quiz']['current_question_id'])

    answer_codes = nil

    if question.multiple?
      if params[:answer].try('[]', :codes).is_a?(Array)
        answer_codes = params[:answer][:codes]
      end
    else
      if params[:answer].try('[]', :code).is_a?(String)
        answer_codes = Array.wrap(params[:answer][:code])
      end
    end

    if answer_codes.present?
      answers = question.answers.where(:code => answer_codes)
      answer_ids = answers.map(&:id)

      if answer_ids.all?{|id| question.answer_ids.include?(id) }
        session['quiz']['answers'][question.id] = answer_ids
        next_question = quiz.questions.where('position > ?', question.position).first

        if next_question.present?
          session['quiz']['current_question_id'] = next_question.id
          redirect_to quiz_question_path
        else
          finish_quiz(quiz)
        end
      end
    else
      redirect_to quiz_question_path
    end
  end

  private

  def finish_quiz(quiz)
    if session['quiz']['answers'].size.eql?(quiz.questions.size)
      style_report = current_spree_user.build_style_report

      if session['quiz']['answers'].values.all?(&:present?)
        session['quiz']['answers'].each do |question_id, answer_ids|
          answers = Answer.where(:id => answer_ids)

          StyleReport::STYLE_ATTRIBUTES.each do |attribute|
            points = answers.map{|answer| answer.send(attribute) }.reduce(:+) / answers.count

            style_report.send("#{attribute}=", style_report.send(attribute) + points)
          end
        end

        style_report.save

        redirect_to thanks_quiz_path
      end
    else
      redirect_to quiz_path
    end
  end
end
