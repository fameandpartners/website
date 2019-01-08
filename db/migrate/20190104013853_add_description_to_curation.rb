class AddDescriptionToCuration < ActiveRecord::Migration
  def change
    add_column :curations, :description, :text
  end
end
