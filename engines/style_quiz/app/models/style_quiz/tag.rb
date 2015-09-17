class StyleQuiz::Tag < ActiveRecord::Base
  GROUPS = %W{color pattern style fabric feature trend}
  WEIGHTS = { color: 3, style: 2, pattern: 1, fabric: 1, feature: 1, trend: 1, default: 1 }

  validates :group, presence: true, inclusion: ::StyleQuiz::Tag::GROUPS
  validates :name,  presence: true, uniqueness: {  scope: :group, case_sensitive: false }

  attr_accessible :group, :name

  def weight
    ::StyleQuiz::Tag::WEIGHTS[self.group.to_sym] || ::StyleQuiz::Tag::WEIGHTS[:default]
  end
end
