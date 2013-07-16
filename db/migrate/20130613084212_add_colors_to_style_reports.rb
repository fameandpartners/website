class AddColorsToStyleReports < ActiveRecord::Migration
  def change
    add_column :style_reports, :colors, :string
  end
end
