class StyleQuiz::Answer < ActiveRecord::Base
  belongs_to :question, class_name: 'StyleQuiz::Question', foreign_key: 'question_id'

  serialize :tags, Array
end
