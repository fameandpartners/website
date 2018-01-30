class ChangeRenderUrlsToJsonb < ActiveRecord::Migration
  def change
  		change_column :customization_visualizations, :render_urls, 'jsonb USING CAST(render_urls as jsonb)'
  end
	end
end
