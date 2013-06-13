class Question < ActiveRecord::Base
  attr_accessible :text,
                  :position,
                  :partial,
                  :multiple,
                  :populate

  belongs_to :quiz

  has_many :answers,
           :dependent => :destroy

  validates :text,
            :presence => true,
            :uniqueness => {
              :scope => :quiz_id
            }

  validates :position,
            :presence => true,
            :numericality => {
              :only_integer => true,
              :greater_than => 0
            }

  validates :partial,
            :presence => true,
            :uniqueness => true
end
