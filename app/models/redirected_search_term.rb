class RedirectedSearchTerm < ActiveRecord::Base
  attr_accessible :redirect_to, :term
end
