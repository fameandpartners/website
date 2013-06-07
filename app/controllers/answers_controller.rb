class AnswersController < ApplicationController
  before_filter :authenticate_spree_user!

  layout nil

  def create
    quiz = Quiz.first
    question = quiz.questions.find(session['quiz']['current_question_id'])

    answer_codes = nil

    if question.multiple?
      if params[:answer][:codes].is_a?(Array)
        answer_codes = params[:answer][:codes]
      end
    else
      if params[:answer][:code].is_a?(String)
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
      if session['quiz']['answers'].values.all?(&:present?)
        answer_ids = session['quiz']['answers'].values.flatten
        answers = Answer.where(:id => answer_ids)

        style_report = current_spree_user.build_style_report

        StyleReport::STYLE_ATTRIBUTES.each do |attribute|
          summary = answers.sum(attribute)
          style_report.assign_attributes(attribute => summary)
        end

        style_report.save

        redirect_to report_quiz_path
      end
    else
      redirect_to quiz_path
    end
  end
end
