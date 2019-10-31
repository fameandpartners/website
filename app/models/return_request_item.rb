class ReturnRequestItem < ActiveRecord::Base

  ACTIONS = %w{keep exchange return}
  REASON_CATEGORY_MAP = {
    "Looks different to image on site" => [
      "Dress does not sit on the body as shown on the website",
      "Colour does not match the colour displayed on the website",
      "Fabric is different to what is represented on the website",
      "The dress simply didn't meet my expectations"
    ],
    "Ordered multiple styles or sizes" => [
      "I was not sure which dress would suit me",
      "I was unsure of the best size for me",
      "I loved so many dresses I found it difficult to choose"
    ],
    "Delivery issues"                  => [
      "My order was late, so I missed my event",
      "The delivery times on the website were not clear",
      "My order was held up in transit",
      "I received a different size to what I ordered",
      "I received a different style to what I ordered",
      "I only received part of my order"
    ],
    "Poor quality or faulty"           => [
      "Dress was damaged when it arrived",
      "Dress was a poor fit",
      "Dress had marks on it",
      "Fabric was poor quality",
      "Zipper was damaged",
      "Dress was poorly made, in my opinion",
      "Lining fabric looked cheap",
      "I did not receive my customisation"
    ],
    "Size and fit"                     => [
      "Dress was too long",
      "Dress was too short",
      "Dress was too big around the bust",
      "Dress was too small around the bust",
      "Dress was too big around the waist",
      "Dress was too small around the waist",
      "Dress was too loose on the hips",
      "Dress was too tight on the hips",
      "Fit was unflattering",
      "Neckline was too low or too open",
      "Shoulder straps were too long",
      "Neck tie was too tight",
      "Shoulder pads fitted poorly",
      "I did not receive my customisation"
    ]
  }
  REASON_CATEGORIES = REASON_CATEGORY_MAP.keys
  REASON_SUB_CATEGORIES = REASON_CATEGORY_MAP.values.flatten

  attr_accessible :order_return_request, :line_item,  :line_item_id, :quantity, :action, :reason_category, :reason

  belongs_to :order_return_request
  belongs_to :line_item, :class_name => 'Spree::LineItem'
  has_one :item_return, foreign_key: :request_id

  delegate :image_url, :style_name, :country_size, :colour_name, :display_price, :to => :line_item_presenter
  delegate :order, to: :line_item

  validates :line_item, :action, :presence => true
  validates :action, :inclusion => { :in => ACTIONS }

  validates :reason_category, :presence => true, :unless => Proc.new { |o| o.keep? }

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
    puts "push_return_event"
    ReturnRequestItemMapping.new(return_request_item: self).call
  # Note: I had troubles with debug because of this rescue
  # Probably we need to handle this exception another way
  # Nickolay 2017-01-30
  rescue StandardError => e
    NewRelic::Agent.notice_error e
  end

  class ReturnRequestItemMapping

    attr_reader :rri, :logger

    def initialize(return_request_item:, logdev: $stdout)
      @rri = return_request_item
      @logger = Logger.new(logdev)
      @logger.formatter = LogFormatter.terminal_formatter
      puts "ReturnRequestItemMapping initialize"
    end

    def call
      puts "ReturnRequestItemMapping call"
      puts "rri.action: " + rri.action.to_s
      return :no_action_required if rri.action == "keep"
      puts "ReturnRequestItemMapping keep"

      requested_item_return = ItemReturn.where(line_item_id: rri.line_item_id).first.presence || ItemReturnEvent.creation.create(line_item_id: rri.line_item_id).item_return
      puts "llllllll line_item_id: "
      puts "llllllll line_item_id: " + rri.line_item_id.to_s

      existing_event = requested_item_return.events.return_requested.detect { |re| re.request_id == rri.id }
      if existing_event.present?
        logger.warn "SKIPPING return_requested - #{rri.line_item_id}, Event Exists"
        puts "SKIPPING return_requested - #{rri.line_item_id}, Event Exists"
        return
      end

      item_price_adjuster = ItemPriceAdjustmentSplit.new(rri.line_item)

      attrs = {
        order_number:           rri.order.number,
        line_item_id:           rri.line_item.id,
        item_price:             item_price_adjuster.item_price_in_cents,
        item_price_adjusted:    item_price_adjuster.item_price_adjusted_in_cents,
        order_paid_currency:    rri.line_item.currency,
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

      puts "attrs: " + attrs.to_s
      puts "order:" + rri.order.number.to_s
      payments = rri.order.payments
      payments = payments.to_a
      payments.each do |py|
        puts "payment id: " + py.id.to_s
        puts "payment source type: " + py.source_type.to_s
        puts "payment state: " + py.state.to_s
      end

      payments = rri.order.payments.completed
      payments = payments.to_a
      payments.each do |py|
        puts "payment11 id: " + py.id.to_s
        puts "payment11 source type: " + py.source_type.to_s
        puts "payment11 state: " + py.state.to_s
      end

      puts "kkkkkkkk"

      if rri.order.payments.completed.last
        puts "iiiiiiii1"
        payment = ::Reports::Payments::PaymentReportPresenter.from_payment(rri.order.payments.last)
        puts "iiiiiiii2"
        puts "iiiiiiii3" + payment.currency.to_s
        puts "payment_type: " + payment.payment_type.to_s
        puts "payment_date: " + payment.payment_date.to_s
        puts "amount_in_cents: " + payment.amount_in_cents.to_s
        puts "transaction_id: " + payment.transaction_id.to_s
        attrs.merge!(
          order_payment_method: payment.payment_type,
          order_payment_date:   payment.payment_date,
          order_paid_amount:    payment.amount_in_cents,
          order_paid_currency:  payment.currency,
          order_payment_ref:    payment.transaction_id,
        )
      end
      puts "pppppppp attrs: " + attrs.to_s
      requested_item_return.events.return_requested.create(attrs)
      puts "pppppppplll attrs: " + attrs.to_s
    end
  end
end
