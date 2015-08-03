module LandingPage
  class Page < ActiveRecord::Base
    attr_accessible :title, :path
    self.table_name = 'landing_pages'

    validates :path, :presence => true, :uniqueness => true
    validates :title, :presence => true

  end
end
