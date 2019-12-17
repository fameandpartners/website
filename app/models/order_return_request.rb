class OrderReturnRequest < ActiveRecord::Base
  attr_accessible :order, :order_id, :return_request_items_attributes

  belongs_to :order, :class_name => 'Spree::Order'

  delegate :number, :completed_at, :name, :phone_number, :shipping_address, :to => :order_presenter

  has_many :return_request_items
  accepts_nested_attributes_for :return_request_items

  def build_items
    puts "OrderReturnRequest.build_items"
    order.line_items.each do |line_item|
      return_request_items.build(:order_return_request => self, :line_item => line_item)
    end
  end

  def order_presenter
    @order_presenter = Orders::OrderPresenter.new(order)
  end

  def sorted_return_request_items
    return_request_items.sort_by { |i| ReturnRequestItem::ACTIONS.index(i.action) }.reverse
  end
end
