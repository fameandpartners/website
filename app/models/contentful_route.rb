class ContentfulRoute < ActiveRecord::Base
  attr_accessible :action,
                  :controller,
                  :route_name

  validates_uniqueness_of :route_name
end
