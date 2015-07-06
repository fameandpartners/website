module Spree::Admin::StyleQuiz
  class AnswersController < Spree::Admin::StyleQuiz::BaseController
    before_filter :question

    def index
      @answers = question.answers
    end

    private

      def model_class
        ::StyleQuiz::Answer
      end

      def question
        @question ||= ::StyleQuiz::Question.find(params[:question_id])
      end
  end
end
