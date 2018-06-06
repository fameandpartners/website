module Newgistics
	class NewgisticsScheduler < ActiveRecord::Base
	  attr_accessible :last_successful_run
	end
end