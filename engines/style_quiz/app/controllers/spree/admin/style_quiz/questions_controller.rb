module Spree::Admin::StyleQuiz
  class QuestionsController < Spree::Admin::StyleQuiz::BaseController
    def index
      @questions = ::StyleQuiz::Question.ordered
    end

    # update questions order
    def order
      params[:positions].each do |question_id, position|
        model_class.update_all({ position: position}, { id: question_id })
      end

      head :ok
    end

    private

      def model_class
        ::StyleQuiz::Question
      end
  end
end
