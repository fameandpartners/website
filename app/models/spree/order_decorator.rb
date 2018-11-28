Spree::Order.class_eval do
  include Spree::Order::CloneShipAddress
  extend Spree::Order::Scopes

  attr_accessible :required_to, :email, :customer_notes, :user_id, :autorefundable
  self.include_root_in_json = false

  has_one :traffic_parameters, class_name: Marketing::OrderTrafficParameters

  checkout_flow do
    go_to_state :address
    go_to_state :payment, :if => lambda { |order|
      # Fix for #2191
      if order.shipping_method
        order.create_shipment!
        order.update_totals
      end
      order.payment_required?
    }
    go_to_state :confirm, :if => lambda { |order| order.confirmation_required? }
    go_to_state :complete, :if => lambda { |order| (order.payment_required? && order.has_unprocessed_payments?) || !order.payment_required? }
  end

  def save_permalink(permalink_value=nil)
    # noop
    # :number is already unique, and already the permalink value
    # The default spree implementation here does a LIKE '?%',
    # which on order number, is very very slow.
  end

  def returnable?
    !(order_return_requested? || has_unshipped_line_item)
  end

  def has_unshipped_line_item
    line_items.any? { |li| !Fabrication.for(li).shipped? }
  end

  def order_return_requested?
    OrderReturnRequest.exists?(:order_id => id)
  end

  def shipped?
    shipment_state == 'shipped'
  end

  def item_count
    line_items.reject{|p| p.style_name == 'RETURN_INSURANCE'}.sum{|product| product.quantity}
  end

  def fabrication_status
    fabrication_states = line_items.collect {|i| i.fabrication.state if i.fabrication }.uniq
    return :processing if fabrication_states.include?(nil)
    fabrication_states.sort_by {|i| Fabrication::STATE_ORDER.index(i) }.first
  end

  def create_shipment!
    shipping_method(true)
    return unless shipments.empty?
    self.shipments = Shipping::AssignByFactory.new(self).create_shipments!
  end

  def cache_key
    "orders/#{id}-#{updated_at.to_s(:number)}"
  end

  def has_personalized_items?
    line_items.includes(:personalization).any?{|line_item| line_item.personalization.present? }
  end

  def has_items_on_sale?
    line_items.any?(&:in_sale?)
  end
  alias :in_sale? :has_items_on_sale?

  def update!
    if self.shipping_method.blank?
      self.update_attribute(:shipping_method_id, Services::FindShippingMethodForOrder.new(self).get.try(:id))
      self.reload
      create_shipment!
    end

    # we need update adjustments first,
    # bcz custom shipping calculator check order total, includings adjusments total,
    # not only items total
    updater.update_adjustments
    updater.update
  end

  # originally, spree allows only one action adjustment from promotion for for order
  def promotion_action_credit_exists?(promotion_action)
    !! adjustments.promotion.reload.detect do |credit|
      credit.originator_id == promotion_action.id && credit.originator.promotion.id == promotion_action.promotion.id
    end
  end

  def display_promotion_total
    if self.adjustments.credit.eligible.any? {|x| x.originator_type == 'Spree::PromotionAction' && x.originator.promotion.code.include?('DELIVERYDISC')}
      promotion_total = self.adjustments.credit.eligible.sum(:amount) + (self.item_total * 0.1)
    else
      promotion_total = self.adjustments.credit.eligible.sum(:amount)
    end
    Spree::Money.new(promotion_total, { currency: currency })
  end

  def promotions
    applied_promotions | eligible_pending_promotions
  end

  def applied_promotions
    self.adjustments.promotion.eligible.map do |credit|
      credit.originator.promotion
    end
  end

  def eligible_pending_promotions
    self.adjustments.promotion.select(&:eligible_for_originator?).collect do |adj|
      adj.originator.promotion
    end
  end

  def promocode
    if promo = coupon_code_added_promotion
      if promo.code.include?('DELIVERYDISC') && promo.code != 'DELIVERYDISC'
        return promo.code.to_s.upcase.split('DELIVERYDISC').first + 'DELIVERYDISC'
      else
        return promo.code.to_s.upcase
      end
    end
  end

  def coupon_code_added_promotion
    promotions.detect {|promo| promo.event_name == "spree.checkout.coupon_code_added" }
  end

  def confirmation_required?
    false
  end

  has_many :payment_requests

  def process_payments!
    begin
      pending_payments.each do |payment|
        break if payment_total >= total
        payment.process!

        if payment.completed?
          self.payment_total += payment.amount
        end
      end
    rescue Spree::Core::GatewayError => e
      result = !!Spree::Config[:allow_checkout_on_gateway_error]
      errors.add(:base, e.message) and return result
    end
  end

  def first_name
    self.user_first_name.present? ? self.user_first_name : self.user.try(:first_name)
  end

  def last_name
    self.user_last_name.present? ? self.user_last_name : self.user.try(:last_name)
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def deliver_order_confirmation_email
    begin
      Spree::OrderMailer.confirm_email(self.id).deliver
      Spree::OrderMailer.team_confirm_email(self.id).deliver
      ProductionOrderEmailService.new(self).deliver
    rescue Exception => e
      log_confirm_email_error(e)
      logger.error("#{e.class.name}: #{e.message}")
      logger.error(e.backtrace * "\n")
    end
  end

  # CURRENTLY , WE ARE ADDING NEW LINE_ITEM PER REQUEST IN ORDER TO ALLOW MULTIPLE CUSTOMIZED DRESSES TO BE ADDED TO CART
  # ( THE OLD LOGIC OF PULLING LINE_ITEM BASED ON VARIANT_ID IS GOT RID OF )
  # WITH THIS SOLUTION , WE ARE NOW HAVING AN SMALL ISSUE WITH MULTIPLE SAME ITEM WITH QUANTITY = 1
  # SINCE THIS SMALL ISSUE IS NOT REALLY DAMAGING , WE WANT TO LEAVE IT LIKE THAT FOR NOW
  def add_variant(variant, quantity = 1, currency = nil)
    prices_amount = get_prices_amount(variant, currency || self.currency)

    current_item = Spree::LineItem.new(:quantity => quantity)
    current_item.variant = variant

    if currency
      current_item.currency = currency
    end

    if prices_amount[:sale_amount].present?
      current_item.price = prices_amount[:sale_amount]
      # current_item.old_price = prices_amount[:original_amount] disabled because it doesnt include customisations
    else
      current_item.price = prices_amount[:original_amount]
    end

    self.line_items << current_item
    self.reload
    current_item
  end

  def update_line_item(current_item, variant, quantity, currency)
    prices_amount = get_prices_amount(variant, currency)

    current_item.currency    = currency
    current_item.variant     = variant
    current_item.quantity    = quantity

    if prices_amount[:sale_amount].present?
      current_item.price = prices_amount[:sale_amount]
      # current_item.old_price = prices_amount[:original_amount] disabled because it doesnt include customisations
    else
      current_item.price = prices_amount[:original_amount]
    end

    current_item.save
    self.reload
  end

  def get_prices_amount(variant, currency)
    price  = variant.price_in(currency)

    {
      sale_amount: price.apply(variant.product.discount).amount,
      original_amount: price.amount
    }
  end

  def log_confirm_email_error(error = nil)
    NewRelic::Agent.agent.error_collector.notice_error( error )
    File.open(File.join(Rails.root, 'log', 'errors.log'), 'a+') do |file|
      file.puts(Time.now.to_s(:db))
      file.puts("order_id: #{ self.id }")
      file.puts(error.inspect)
      file.puts(error.try(:backtrace))
      file.puts
    end
  end

  def customer_shipping_address
    return unless ship_address.present?
    components = ship_address.attributes.slice(*%w[address1 address2 city]).values
    components << ship_address.state_text
    components << ship_address.zipcode
    components << ship_address.country.name
    components.reject(&:blank?).join(', ')
  end

  def customer_full_name
    user.try(:full_name) || [user_first_name, user_last_name].join(' ')
  end

  def customer_email
    user.try(:email) || email
  end

  def as_csv
    result = as_json({
      only: [:number, :created_at, :total, :adjustment_total, :currency],
      methods: [:customer_email, :customer_full_name, :customer_shipping_address]
    })
    line_item_columns = [:style_name, :sku, :colour, :size, :customisations, ]
    line_item_columns.each do |line_item_column|
      result[line_item_column] = []
    end
    line_items.includes(:product, :variant).each do |line_item|
      result[:style_name] << (line_item.product.present? ? line_item.product.name : 'Deleted Product')
      result[:sku]        << (line_item.variant.present? ? line_item.variant.sku : 'n/a')

      size = 'n/a'
      colour = 'n/a'
      customisations = 'n/a'

      if line_item.variant.present?
        line_item.variant.option_values.each do |value|
          case value.option_type.name.to_s.downcase
          when 'dress-size'
            size = value.presentation
          when 'dress-color'
            colour = value.presentation
          else
            customisations = "#{value.option_type.presentation}: #{value.presentation}"
          end
        end
      end
      result[:size] << size
      result[:colour] << colour
      result[:customisations] << customisations
    end
    line_item_columns.each do |line_item_column|
      result[line_item_column] = result[line_item_column].join('|')
    end
    result
  end

  def get_site_version
    @site_version ||= SiteVersion.by_currency_or_default(self.currency)
  end

  def use_prices_from(site_version)
    return if self.currency == site_version.currency
    return if self.completed?

    # update line items
    # update currency
    self.currency = site_version.currency

    self.line_items.each do |current_item|
      variant = current_item.variant
      price = variant.site_price_for(site_version)

      current_item.currency = price.currency

      if variant.in_sale?
        current_item.price = price.apply(variant.discount).amount
        current_item.old_price = price.amount
      else
        current_item.price = price.amount
      end
    end
    self.save

    self.reload
  end

  def after_cancel
    restock_items!
    #TODO: make_shipments_pending
    Marketing::CancelOrderTracker.new(self).send_customerio_event
    unless %w(partial shipped).include?(shipment_state)
      self.payment_state = 'credit_owed'
    end
  end

  def contains_sample_sale_item?
    return self.line_items.any? {|item| !item.stock.nil?}
  end

  def return_eligible_AC?
    return false unless completed?
    self.return_type.blank? || self.return_type == 'C'|| (self.return_type == 'A' && !self.promotions.any? {|x| x.code.downcase.include? "deliverydisc"}) #blank? handles older orders so we dont need to back fill
  end

  def return_eligible_B?
    return false unless completed?
    
    self.completed_at.between?( DateTime.new(2018,11,20), DateTime.new(2018,11,30) ) ||
      ( self.return_type == 'B' && self.line_items.any? {|x| x.product.name.downcase.include? "return_insurance"} )
  end

  def return_eligible?
    max_delivery_date = line_items.map(&:delivery_period_policy).map(&:delivery_date).compact.max

    self.line_items.any?{|x| x.stock.nil?} && (self.return_eligible_B? || self.return_eligible_AC?) && 60.days.ago <= max_delivery_date
  end

  def final_return_by_date
    max_delivery_date = line_items.map(&:delivery_period_policy).map(&:delivery_date).compact.max
    (max_delivery_date + 60)
  end

  def as_json(options = { })
    json = super(options)
    json['date_iso_mdy'] = self.created_at.strftime("%m/%d/%y")
    json['final_return_by_date'] = self.final_return_by_date&.strftime("%m/%d/%y")
    json['international_customer'] = self.shipping_address&.country_id != 49 || false
    json['is_australian'] = self.shipping_address&.country_id === 109 || false
    json['return_eligible'] = self.return_eligible?

    json
  end

  #hijack method, original merge logic was faulty cause variant_id is not unique enough
  # so as a cleaner solution=drop the older cart, newer cart becomes current cart
  def merge!(order)
    if self.line_items.count > 0
      order.destroy
    else
      self.billing_address = self.billing_address || order.billing_address
      self.shipping_address = self.shipping_address || order.shipping_address
      order.line_items.each do |line_item|
        next unless line_item.currency == currency
        line_item.order_id = self.id
        line_item.save
      end

    end
  end

  def legit_line_items
    self.line_items.reject { |x|
      x.product.name.downcase == 'return_insurance'
    }
  rescue
    self.line_items
  end
end
