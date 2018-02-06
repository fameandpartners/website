class AddSillouhetteAndNecklineToVisualization < ActiveRecord::Migration
  def change
  	add_column :customization_visualizations, :silhouette, :string
  	add_column :customization_visualizations, :neckline, :string
  end
end
