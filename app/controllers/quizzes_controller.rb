class QuizzesController < ApplicationController
  before_filter :authenticate_spree_user!

  layout 'quiz'

  def show
    @quiz = Quiz.last
  end

  def start
    quiz = Quiz.last
    first_question = quiz.questions.first
    session['quiz'] = {}
    session['quiz']['answers'] = {}
    session['quiz']['current_question_id'] = first_question.id

    redirect_to quiz_question_path
  end

  def report

  end
end
