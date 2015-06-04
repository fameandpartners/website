#  this file wrappes StyleQuiz::Question objects
#  and returns user-specific information
#  already answered, preferred values, etc
#
module StyleQuiz; end

class StyleQuiz::UserQuestions
  attr_reader :user
  def initialize(user:)
    @user = user
  end

  def read_all
    StyleQuiz::Question.active.ordered.includes(:answers).to_a
  end
end
