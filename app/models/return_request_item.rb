class ReturnRequestItem < ActiveRecord::Base
  attr_accessible :order_return_request, :line_item,  :line_item_id, :quantity, :action, :reason_category, :reason

  belongs_to :order_return_request
  belongs_to :line_item, :class_name => 'Spree::LineItem'

  delegate :image_url, :style_name, :country_size, :colour_name, :display_price, :to => :line_item_presenter

  validates :line_item, :action, :presence => true

  validates :reason_category, :reason, :presence => true, :unless => Proc.new { |o| o.keep? }

  after_initialize :set_defaults

  ACTIONS = %w{keep exchange return}

  def set_defaults
    self.action = 'keep' unless self.action
    self.quantity = 1
    if keep?
      self.reason_category = nil
      self.reason = nil
    end
  end

  def action=(new_action)
    write_attribute(:action, new_action.to_s.downcase)
  end

  def line_item_presenter
    @line_item_presenter ||= Orders::LineItemPresenter.new(line_item, order)
  end

  def order
    order_return_request.order
  end

  def order_quantity
    line_item_presenter.quantity
  end

  def line_item_id
    line_item.id
  end

  def keep?
    action.downcase == 'keep'
  end

  def return_or_exchange?
    !keep?
  end

end
