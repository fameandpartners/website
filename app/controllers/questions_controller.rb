class QuestionsController < ApplicationController
  before_filter :authenticate_spree_user!

  include SslRequirement
  ssl_allowed

  layout nil

  def index
    @quiz = Quiz.last
  end

  def show
    @quiz = Quiz.last
    @question = @quiz.questions.find(params[:id])
    @position = @quiz.questions.index(@question) + 1
    @progress = (100.0 / @quiz.questions.count * @quiz.questions.index(@question)).round
  end
end
