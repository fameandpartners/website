class OrderReturnRequest < ActiveRecord::Base
  attr_accessible :order, :order_id, :return_request_items_attributes

  belongs_to :order, :class_name => 'Spree::Order'

  delegate :number, :completed_at, :name, :phone_number, :shipping_address, :to => :order_presenter

  has_many :return_request_items
  accepts_nested_attributes_for :return_request_items

  after_initialize :load_order

  def build_items
    order.line_items.each do |line_item|
      return_request_items.build(:order_return_request => self, :line_item => line_item)
    end
  end

  def order_presenter
    @order_presenter = Orders::OrderPresenter.new(order)
  end

  def load_order
    if order_id && !order
      @order = Order.find(order_id)
    end
  end
end
