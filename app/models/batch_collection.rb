class BatchCollection < ActiveRecord::Base
  attr_accessible :batch_key, :status

  has_many :batch_collection_line_items, :order => 'projected_delivery_date ASC'   #todo: this ordering needs to be verified
  has_many :line_items, :through => :batch_collection_line_items, dependent: :destroy

end
