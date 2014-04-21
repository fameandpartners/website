Spree::Order.class_eval do
  self.include_root_in_json = false

  attr_accessor :zone_id
  attr_accessible :required_to

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

  def cache_key
    "orders/#{id}-#{updated_at.to_s(:number)}"
  end

  def clean_cache!
    ActiveSupport::Cache::RedisStore.new.delete_matched("*#{cache_key}*")
  end

  def sale_shipping_method
    Spree::ShippingMethod.find_by_name('sale_11_95')
  end

  def has_sale_shipping?
    sale_shipping_method.present? && shipments.exists?(shipping_method_id: sale_shipping_method.id)
  end

  def has_personalized_items?
    line_items.map(&:personalization).any?(&:present?)
  end

  def update!
    if sale_shipping_method.present? && ((shipping_method.nil? && Spree::Sale.first.try(:active?)) || has_sale_shipping?)
      update_totals

      if item_total < 100
        unless has_sale_shipping?
          self.shipping_method = sale_shipping_method
          create_shipment!
        end
      elsif has_sale_shipping?
        shipments.find_by_shipping_method_id(sale_shipping_method.id).try(:destroy)
      end
    end

    updater.update
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
      log_products_purchased
      update_campaign_monitor
    rescue Exception => e
      log_confirm_email_error(e)
      logger.error("#{e.class.name}: #{e.message}")
      logger.error(e.backtrace * "\n")
    end
  end

  def add_variant(variant, quantity = 1, currency = nil)
    current_item = find_line_item_by_variant(variant)
    if current_item
      current_item.quantity += quantity
      current_item.currency = currency unless currency.nil?
      current_item.save
    else
      if @zone_id
        price = variant.zone_price_for(Spree::Zone.find(@zone_id))
      else
        price = variant.price_in(currency)
      end
      current_item = Spree::LineItem.new(:quantity => quantity)
      current_item.variant = variant
      if currency
        current_item.currency    = currency unless currency.nil?
        current_item.price       = price.final_amount
        if variant.in_sale?
          current_item.old_price = price.amount_without_discount
        end
      else
        current_item.price       = price.final_price
        if variant.in_sale?
          current_item.old_price = price.price_without_discount
        end
      end
      self.line_items << current_item
    end

    self.reload
    current_item
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
      only: [:number, :created_at],
      methods: [:customer_email, :customer_full_name, :customer_shipping_address]
    })
    line_item_columns = [:style_name, :sku, :colour, :size, :customisations]
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

    self.zone_id = site_version.zone_id
    
    # update line items
    # update currency
    self.currency = site_version.currency

    self.line_items.each do |current_item|
      variant = current_item.variant
      price = variant.zone_price_for(Spree::Zone.find(@zone_id))

      # if price or currency has been changed
      if current_item.price.to_i != price.final_amount.to_i && current_item.currency != price.currency
        current_item.currency = price.currency
        current_item.price = price.final_amount
        if variant.in_sale?
          current_item.old_price = price.amount_without_discount
        end
        current_item.save
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
