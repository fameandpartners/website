class ItemReturnLabel < ActiveRecord::Base
  attr_accessible :carrier, :label_image_url, :label_pdf_url, :label_url
  has_many :item_return
end
