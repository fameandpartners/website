class AddIndexToVisualizations < ActiveRecord::Migration
  def change
  	add_index(:customization_visualizations, [:length, :silhouette, :neckline], name: 'dress_features')
  end
end
