class QuestionsController < ApplicationController
  before_filter :authenticate_spree_user!

  include SslRequirement
  ssl_allowed

  layout nil

  def index
    @quiz = Quiz.last
    Activity.log_quiz_started(@quiz, current_spree_user)
  end
end
