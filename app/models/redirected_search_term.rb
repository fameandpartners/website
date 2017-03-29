class RedirectedSearchTerm < ActiveRecord::Base
  attr_accessible :redirect_to, :term
  validates_presence_of :term
  validates_uniqueness_of :term
  validates_presence_of :redirect_to

  before_validation :downcase_term
  before_save :format_redirect_to
  private
  
  def downcase_term
    self.term = self.term.downcase if self.term.present?
  end

  def format_redirect_to
    self.redirect_to = self.redirect_to.chomp('/')
    self.redirect_to = "/#{self.redirect_to}" if( ( self.redirect_to.index( 'http' ) != 0 ) && (self.redirect_to.index( '/' ) != 0 ) )
  end
  
end
