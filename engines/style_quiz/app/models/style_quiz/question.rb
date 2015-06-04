class StyleQuiz::Question < ActiveRecord::Base
  has_many :answers, class_name: 'StyleQuiz::Answer', foreign_key: 'question_id'
  validates :code, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order('position asc') }
end
