class BatchCollection < ActiveRecord::Base
  attr_accessible :batch_key, :status

  has_many :batch_collection_line_items
  has_many :line_items, :through => :batch_collection_line_items

end
