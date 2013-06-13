class AddBrandsToStyleReports < ActiveRecord::Migration
  def change
    add_column :style_reports, :brands, :string
  end
end
