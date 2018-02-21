class BatchCollection < ActiveRecord::Base
  attr_accessible :style

  has_many :batch_collection_line_items
  has_many :line_items, :through => :batch_collection_line_items, dependent: :destroy

end
