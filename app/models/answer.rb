class Answer < ActiveRecord::Base
  attr_accessible :question,
                  :code,
                  :glam,
                  :girly,
                  :classic,
                  :edgy,
                  :bohemian,
                  :sexiness,
                  :fashionability

  belongs_to :question

  validates :code,
            :presence => true,
            :uniqueness => {
              :scope => :question_id
            }

  validates :question,
            :presence => true
end
