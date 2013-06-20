class QuestionsController < ApplicationController
  before_filter :authenticate_spree_user!

  layout nil

  def index
    @quiz = Quiz.first
  end

  def show
    @quiz = Quiz.first
    @question = @quiz.questions.find(params[:id])
    @position = @quiz.questions.index(@question) + 1
    @progress = 100 / @quiz.questions.count * @quiz.questions.index(@question)
  end
end
