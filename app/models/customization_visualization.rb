class CustomizationVisualization < ActiveRecord::Base
	belongs_to :product,
	         class_name: 'Spree::Product'

	attr_accessible :customization_ids,
	              :product_id,
	              :incompatible_ids,
	              :render_urls,
	              :length,
	              :neckline,
	              :silhouette

end