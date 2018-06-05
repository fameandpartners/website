class AddScheduleName < ActiveRecord::Migration
	def up
		add_column :newgistics_schedulers, :name, :string
	end

	def down
		remove_column :newgistics_schedulers, :name
	end
end
