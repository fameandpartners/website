class StyleQuiz::Answer < ActiveRecord::Base
  belongs_to :question, class_name: 'StyleQuiz::Question', foreign_key: 'question_id'
  has_many :answer_tags, class_name: 'StyleQuiz::AnswerTag', foreign_key: 'answer_id'
  has_many :tags, through: :answer_tags
end
