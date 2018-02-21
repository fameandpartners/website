class Fabric < ActiveRecord::Base
	attr_accessible :name, :presentation
 	belongs_to :option_value,
 			class_name: 'Spree::OptionValue'

 	has_many :line_items,
			 class_name: 'Spree::LineItem'
  	has_and_belongs_to_many :products,
  							class_name: 'Spree::Product'


end
