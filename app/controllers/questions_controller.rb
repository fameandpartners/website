class QuestionsController < ApplicationController
  before_filter :authenticate_spree_user!

  layout 'quiz'

  def show
    @quiz = Quiz.first
    @question = @quiz.questions.find(session['quiz']['current_question_id'])
    @progress = 100 / @quiz.questions.count * @quiz.questions.index(@question)
  end
end
