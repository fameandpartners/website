class Theme < ActiveRecord::Base
	attr_accessible :name,
	              :presentation,
	              :color,
	              :collection

end