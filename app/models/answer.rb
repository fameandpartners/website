class Answer < ActiveRecord::Base
#  default_scope order('id ASC')
#  default_values :glam  => 0,
#                 :girly => 0,
#                 :classic => 0,
#                 :edgy => 0,
#                 :bohemian => 0,
#                 :sexiness => 0,
#                 :fashionability => 0
#
#  attr_accessible :question,
#                  :code,
#                  :glam,
#                  :girly,
#                  :classic,
#                  :edgy,
#                  :bohemian,
#                  :sexiness,
#                  :fashionability
#
#  belongs_to :question
#
#  has_many :answer_taxons
#  has_many :taxons,
#           through: :answer_taxons
#
#  validates :code,
#            :presence => true,
#            :uniqueness => {
#              :scope => :question_id
#            }
#  validates :question,
#            :presence => true
#
#  def pointable?
#    !glam.zero? ||
#    !girly.zero? ||
#    !classic.zero? ||
#    !edgy.zero? ||
#    !bohemian.zero?
#  end
end
