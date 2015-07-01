class ReturnRequestItem < ActiveRecord::Base

  ACTIONS = %w{keep exchange return}

  attr_accessible :order_return_request, :line_item,  :line_item_id, :quantity, :action, :reason_category, :reason

  belongs_to :order_return_request
  belongs_to :line_item, :class_name => 'Spree::LineItem'

  delegate :image_url, :style_name, :country_size, :colour_name, :display_price, :to => :line_item_presenter

  validates :line_item, :action, :presence => true
  validates :action, :inclusion => { :in => ACTIONS }

  validates :reason_category, :reason, :presence => true, :unless => Proc.new { |o| o.keep? }

  after_initialize :set_defaults

  after_create :push_return_event


  def set_defaults
    self.action = self.action.presence || 'keep'
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

  private

  def push_return_event
    ItemReturnEvent.where(event_type: :return_requested, line_item_id: line_item.id)

    # existing_item_return =

    item_return = ItemReturn.where(line_item_id: line_item.id).first || ItemReturnEvent.creation.create!(line_item_id: line_item.id).item_return





    binding.pry unless item_return.is_a? ItemReturn
    binding.pry unless item_return.persisted?

    attrs = {
      order_number:           order.number,
      line_item_id:           line_item.id,
      qty:                    quantity,
      requested_action:       action,
      requested_at:           created_at,
      customer_name:          order.full_name,
      reason_category:        reason_category,
      reason_sub_category:    reason,
      request_notes:          '',
      contact_email:          order.email,
      product_name:           line_item.product.name,
      product_style_number:   line_item.product.sku,
      product_colour:         line_item_presenter.colour_name,
      product_size:           line_item_presenter.country_size,
      product_customisations: line_item_presenter.personalizations?,
      acceptance_status:      :requested,
    }

    # TODO PICK THE SUCCESSFUL ONE
    if payment = order.payments.detect { |o| o.state = 'completed' }

      presented_payment = ::PaymentsReport::PaymentReportPresenter.from_payment(payment)
      attrs.merge!(
        order_payment_method: presented_payment.payment_type,
        order_paid_amount:    presented_payment.amount_in_cents,
        order_paid_currency:  presented_payment.currency,
        order_payment_ref:    presented_payment.token
      )
    end

    item_return.events.return_requested.create!(attrs)


  end



end
