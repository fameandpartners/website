class BatchCollectionLineItem < ActiveRecord::Base
  # attr_accessible :projected_delivery_date

  belongs_to :batch_collection
  belongs_to :line_item, class_name: 'Spree::LineItem'

  # def initialize
  #   self.projected_delivery_date = Orders::LineItemPresenter.new(self.line_item).projected_delivery_date
  # end

  def projected_delivery_date
    Orders::LineItemPresenter.new(self.line_item).projected_delivery_date
  end
end
