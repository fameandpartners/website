class QuizzesController < ApplicationController
  layout nil

  def show
    if spree_user_signed_in?
      quiz = Quiz.last
      first_question = quiz.questions.first
      session['quiz'] = {}
      session['quiz']['answers'] = {}
      session['quiz']['current_question_id'] = first_question.id

      redirect_to quiz_questions_path
    else
      render
    end
  end

  def report
    render :layout => 'statics'
  end
end
