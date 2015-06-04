#  this file returns statics questions info from database
#  not user answer or other settings can influence
#  should be heavily cached
#
module StyleQuiz; end

class StyleQuiz::Questions
  def initialize
  end

  def read_all
    StyleQuiz::Question.active.includes(:answers).each do |question|
    end
  end
end
