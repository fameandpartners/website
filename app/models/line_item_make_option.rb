class LineItemMakeOption < ActiveRecord::Base
  belongs_to :product,    class_name: 'Spree::Product' 
  belongs_to :variant,    class_name: 'Spree::Variant'
  belongs_to :line_item,  class_name: 'Spree::Variant'
end
