class CreateNewgisticsSchedulerTable < ActiveRecord::Migration
  def change
  	  create_table :newgistics_schedulers do |t|
      t.string :last_successful_run

      t.timestamps
    end
  end
end
