class StyleQuiz::Tag < ActiveRecord::Base
  has_many :answer_tags, class_name: 'StyleQuiz::AnswerTag', foreign_key: 'tag_id'
  has_many :answers, through: :answer_tags

  GROUPS = %W{color pattern style fabric feature trands}

  validates :group, presence: true, inclusion: ::StyleQuiz::Tag::GROUPS
  validates :name,  presence: true, uniqueness: {  scope: :group, case_sensitive: false }
end
