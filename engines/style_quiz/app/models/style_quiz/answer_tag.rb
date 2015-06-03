class StyleQuiz::AnswerTag < ActiveRecord::Base
  belongs_to :answer, class_name: 'StyleQuiz::Answer', foreign_key: 'answer_id'
  belongs_to :tag, clase_name: 'StyleQuiz::Tag', foreign_key: 'tag_id'
end
