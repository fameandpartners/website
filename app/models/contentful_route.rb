class ContentfulRoute < ActiveRecord::Base
  attr_accessible :action,
                  :controller,
                  :route_name

  validates_uniqueness_of :route_name
  validates_format_of :route_name, :with => /^\/([a-z]{1})([a-z0-9-])+$/, :on => :create
end
