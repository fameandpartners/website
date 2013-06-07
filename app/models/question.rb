class Question < ActiveRecord::Base
  attr_accessible :text,
                  :position,
                  :partial,
                  :multiple

  belongs_to :quiz
  has_many :answers,
           :dependent => :destroy
end
