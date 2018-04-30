class BatchCollectionLineItem < ActiveRecord::Base
  scope :active, -> { where(deleted_at: nil)}

  belongs_to :batch_collection
  belongs_to :line_item, class_name: 'Spree::LineItem'

  def delete
    self.update_column(:deleted_at, Time.now)
  end

  def projected_delivery_date
    Orders::LineItemPresenter.new(self.line_item).projected_delivery_date
  end
end
