class Fabric < ActiveRecord::Base
	attr_accessible :name, :presentation, :price_aud, :price_usd
 	belongs_to :option_value,
 			class_name: 'Spree::OptionValue'

 	has_many :line_items,
			 class_name: 'Spree::LineItem'
  	has_and_belongs_to_many :products,
  							class_name: 'Spree::Product'


  	def price_in(currency)
  		if currency.downcase == 'aud'
  			return self.price_aud.to_f
  		else
  			return self.price_usd.to_f
  		end
  	end
end
