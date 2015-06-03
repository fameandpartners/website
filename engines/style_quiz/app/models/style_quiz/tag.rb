class StyleQuiz::Tag < ActiveRecord::Base
  GROUPS = %W{color pattern style fabric feature trands}

  validates :group, presence: true, inclusion: ::StyleQuiz::Tag::GROUPS
  validates :name,  presence: true, uniqueness: {  scope: :group, case_sensitive: false }
end
