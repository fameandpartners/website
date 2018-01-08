class ChangeRenderUrlsToJsonb < ActiveRecord::Migration
  def change
  		change_column :customization_visualizations, :render_urls, :jsonb, using: 'column_name::jsonb'
	end
end
