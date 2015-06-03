class StyleQuiz::Question < ActiveRecord::Base
  has_many :answers, class_name: 'StyleQuiz::Answer', foreign_key: 'question_id'
  validates :code, uniqueness: true
end
