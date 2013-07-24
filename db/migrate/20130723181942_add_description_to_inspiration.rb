class AddDescriptionToInspiration < ActiveRecord::Migration
  def change
    add_column :celebrity_inspirations, :celebrity_description, :text
  end
end
