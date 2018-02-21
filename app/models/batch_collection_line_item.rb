class BatchCollectionLineItem < ActiveRecord::Base
  belongs_to :batch_collection
  belongs_to :line_item, class_name: 'Spree::LineItem'
end
