class Quiz < ActiveRecord::Base
  attr_accessible :name

  has_many :questions,
           :dependent => :destroy,
           :order => 'position ASC'

  validates :name,
            :presence => true

  class << self
    def active
      Quiz.last
    end

    def style_quiz
      Quiz.where(name: 'Style Quiz').last
    end

    def wedding_quiz
      Quiz.where(name: 'Wedding Quiz').last
    end
  end
end
