class RedirectedSearchTerm < ActiveRecord::Base
  attr_accessible :redirect_to, :term
  validates_presence_of :term
  validates_uniqueness_of :term
  
  validates_presence_of :redirect_to

  before_validation :downcase_term

  private
  def downcase_term
    self.term = self.term.downcase if self.term.present?
  end
  
end
