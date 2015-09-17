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

  def push_return_event
    ReturnRequestItemMapping.new(return_request_item: self).call
  rescue StandardError => e
    NewRelic::Agent.notice_error e
  end

  class ReturnRequestItemMapping

    attr_reader :rri, :logger

    def initialize(return_request_item:, logdev: $stdout)
      @rri = return_request_item
      @logger = Logger.new(logdev)
      @logger.formatter = LogFormatter.terminal_formatter
    end

    def call
      return :no_action_required if rri.action == "keep"

      item_return = ItemReturn.where(line_item_id: rri.line_item_id).first.presence || ItemReturnEvent.creation.create(line_item_id: rri.line_item_id).item_return

      existing_event = item_return.events.return_requested.first
      if existing_event.present?
        logger.warn "SKIPPING return_requested - #{rri.line_item_id}, Event Exists"
        return
      end

      attrs = {
        order_number:           rri.order.number,
        line_item_id:           rri.line_item.id,
        qty:                    rri.quantity,
        requested_action:       rri.action,
        requested_at:           rri.created_at,
        request_id:             rri.id,
        customer_name:          rri.order.full_name,
        reason_category:        rri.reason_category,
        reason_sub_category:    rri.reason,
        request_notes:          '',
        contact_email:          rri.order.email,
        product_name:           rri.line_item.product.name,
        product_style_number:   rri.line_item.product.sku,
        product_colour:         rri.line_item_presenter.colour_name,
        product_size:           rri.line_item_presenter.country_size,
        product_customisations: rri.line_item_presenter.personalizations?,
        acceptance_status:      :requested,
      }

      # TODO PICK THE SUCCESSFUL ONE
      if rri.order.payments.completed.last
        payment = ::Reports::Payments::PaymentReportPresenter.from_payment(rri.order.payments.last)
        attrs.merge!(
          order_payment_method: payment.payment_type,
          order_paid_amount:    payment.amount_in_cents,
          order_paid_currency:  payment.currency,
          order_payment_ref:    payment.token
        )
      end

      item_return.events.return_requested.create(attrs)
    end
  end
end
