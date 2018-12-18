class AddCynStartAndEndDateToMakingOption < ActiveRecord::Migration
  def change
    add_column :making_options, :cny_start_date, :datetime
    add_column :making_options, :cny_end_date, :datetime
  end
end
