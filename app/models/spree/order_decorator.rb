require "#{Rails.root}/app/policies/order_projected_delivery_date_policy"

Spree::Order.class_eval do
  attr_accessible :required_to, :email, :customer_notes, :projected_delivery_date
  self.include_root_in_json = false

  attr_accessor :zone_id

  after_save :clean_cache!

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

  state_machine do
    after_transition :to => :complete, :do => :track_user_bought_dress
    after_transition :to => :complete, :do => :project_delivery_date
  end

  def project_delivery_date
    if complete?
      delivery_date = Policies::OrderProjectedDeliveryDatePolicy.new(self).delivery_date
      update_attribute(:projected_delivery_date, delivery_date)
    end
  end

  def delivery_state
    return 'incomplete' unless complete?
    projected_delivery_date ||= Policies::OrderProjectedDeliveryDatePolicy.new(self).delivery_date
    days = (Time.zone.now.to_date - projected_delivery_date.to_date).to_i
    # binding.pry
    case days
    when 11..999
      'critical'
    when 7..10
      'urgent'
    when 1..6
      'overdue'
    when -2..0
      'due'
    when -10..-3
      'ok'
    else
      'unknown'
    end
  end

  # todo: this should be done in some service, order has no relation to this func
  def track_user_bought_dress
    # TODO: check this works
    if self.user.bridesmaid_party_members.present?
      Bridesmaid::CheckIsDressBoughtByMember.new(order: self).process
    end
  rescue Exception => e
    # do nothing, tracking/notifying shouldn't have any issues
  end

  def create_shipment!
    shipping_method(true)
    if shipment.present?
      # reset instance variable cache, calling shipment again will get it from last shipments ( updated ones )
      @shipment = nil
      shipment.update_attributes!({:shipping_method => shipping_method, :inventory_units => self.inventory_units}, :without_protection => true)
    else
      self.shipments << ::Spree::Shipment.create!({ :order => self,
                                        :shipping_method => shipping_method,
                                        :address => self.ship_address,
                                        :inventory_units => self.inventory_units}, :without_protection => true)
    end
  end

  def cache_key
    "orders/#{id}-#{updated_at.to_s(:number)}"
  end

  def clean_cache!
    ActiveSupport::Cache::RedisStore.new(Rails.application.config.cache_store.last).delete_matched("*#{cache_key}*")
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

  def promotion_total
    if self.shipment.blank?
      self.adjustment_total
    else
      self.adjustments.where("originator_type != 'Spree::ShippingMethod'").eligible.map(&:amount).sum
    end
  end

  def display_promotion_total
    Spree::Money.new(promotion_total, { :currency => currency })
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
      ProductionOrderEmailService.new(self.id).deliver
      log_products_purchased
      update_campaign_monitor
    rescue Exception => e
      log_confirm_email_error(e)
      logger.error("#{e.class.name}: #{e.message}")
      logger.error(e.backtrace * "\n")
    end
  end

  def get_price_for_line_item(variant, zone_id, currency)
    if zone_id
      price = variant.zone_price_for(Spree::Zone.find(zone_id))
    else
      currency ||= self.currency
      price = variant.price_in(currency)
    end

    # Plus Size Pricing
    if add_plus_size_cost?(variant)
      price.amount += 20
    end

    price
  end

  def add_variant(variant, quantity = 1, currency = nil)
    current_item = find_line_item_by_variant(variant)
    if current_item
      current_item.quantity += quantity
      current_item.currency = currency unless currency.nil?
      current_item.save
    else
      price = get_price_for_line_item(variant, @zone_id, currency)
      current_item = Spree::LineItem.new(:quantity => quantity)
      current_item.variant = variant
      if currency
        current_item.currency    = currency

        if variant.in_sale?
          current_item.price = price.apply(variant.discount).amount
          current_item.old_price = price.amount
        else
          current_item.price = price.amount
        end
        #current_item.price       = price.final_amount(is_surryhills?(variant))
        #if variant.in_sale?
        #  current_item.old_price = price.amount_without_discount
        #end
      else
        if variant.in_sale?
          current_item.price = price.apply(variant.discount).amount
          current_item.old_price = price.amount
        else
          current_item.price = price.amount
        end
        #current_item.price       = price.final_amount(is_surryhills?(variant))
        #if variant.in_sale?
        #  current_item.old_price = price.price_without_discount
        #end
      end
      self.line_items << current_item
    end

    self.reload
    current_item
  end

  def update_line_item(current_item, variant, quantity, currency)
    price = get_price_for_line_item(variant, @zone_id, currency)

    current_item.currency    = currency
    current_item.variant     = variant
    current_item.quantity    = quantity

    if variant.in_sale?
      current_item.price = price.apply(variant.discount).amount
      current_item.old_price = price.amount
    else
      current_item.price = price.amount
    end
    #current_item.price       = price.final_amount
    #if variant.in_sale?
    #  current_item.old_price = price.amount_without_discount
    #end

    current_item.save
    self.reload
  end

  def log_products_purchased
    line_items.each do |line_item|
      Activity.log_product_purchased(line_item.product, self.user, self)
    end
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
  #rescue
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

  def add_plus_size_cost?(variant)
    unless variant.product_plus_size
      if variant.dress_size && variant.dress_size.name.to_i >= locale_plus_sizes
        return true
      end
    end
  end

  def locale_plus_sizes
    if get_site_version.permalink == 'au'
      return 18
    else
      return 14
    end
  end

  def is_surryhills?(item)
    if item.product_factory_name == "surryhills"
      return true
    else
      return false
    end
  end

  def use_prices_from(site_version)
    return if self.currency == site_version.currency
    return if self.completed?

    # update line items
    # update currency
    self.currency = site_version.currency

    self.line_items.each do |current_item|
      variant = current_item.variant
      price = variant.zone_price_for(site_version.zone)

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

  def update_campaign_monitor
    if user.present?
      CampaignMonitor.delay.set_purchase_date(user, Date.today)
    end
  end
end
