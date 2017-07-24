class ItemReturnLabel < ActiveRecord::Base
  attr_accessible :carrier, :item_return_id, :label_image_url, :label_pdf_url, :label_url, :tracking_number
  belongs_to :item_return
end
