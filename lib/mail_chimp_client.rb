class MailChimpClient

  attr_accessor :gibbon

  STORE_ID = 'fame_and_partners'

  def initialize
    self.gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
  end

  def add_customer(user)
    return if customer_exists? user

    user_params = {
      id: user.id.to_s,
      email_address: user.email,
      opt_in_status: false
    }

    gibbon.ecommerce.stores(STORE_ID).customers.create(body: user_params)
  rescue StandardError => e
    Raven.capture_exception(e)
  end

  def add_order(order)
    return unless order

    order_params = {
      id: order.number,
      customer: {
        id: order.user.id.to_s,
        email: order.user.email,
        first_name: order.user.first_name,
        last_name: order.user.last_name
      },
      currency_code: order.currency,
      order_total: order.total.to_f,
      lines: order_line_items(order)
    }

    gibbon.ecommerce.stores(STORE_ID).orders.create(body: order_params)
  rescue StandardError => e
    byebug
    Raven.capture_exception(e)
  end

  private

  def customer_exists?(user)
    gibbon.ecommerce.stores(STORE_ID).customers(user.id).retrieve
    true
  rescue Gibbon::MailChimpError
    false
  end

  def product_exists?(product)
    gibbon.ecommerce.stores(STORE_ID).products(product.sku).retrieve
    true
  rescue Gibbon::MailChimpError
    false
  end

  def variant_exists?(product, sku)
    gibbon.ecommerce.stores(STORE_ID).products(product.sku).variants(sku).retrieve
    true
  rescue Gibbon::MailChimpError
    false
  end

  def order_line_items(order)
    order.line_items.map do |line_item|
      product = line_item.variant.product
      add_product(product) unless product_exists?(product)

      sku = CustomItemSku.new(line_item).call
      add_variant(product, sku) unless variant_exists?(product, sku)

      {
        id: line_item.id.to_s,
        product_id: line_item.variant.product.sku,
        product_variant_id: CustomItemSku.new(line_item).call,
        quantity: 1,
        price: line_item.price
      }
    end
  end

  def add_product(product)
    return unless product

    product_params = {
      id: product.sku,
      title: product.name,
      variants: [{ id: product.master.sku, title: product.master.sku }] # MailChimp will not create product without any variant
    }

    gibbon.ecommerce.stores(STORE_ID).products.create(body: product_params)
  end

  def add_variant(product, sku)
    return unless product && sku

    variant_params = {
      id: sku,
      title: product.name,
      sku: sku
    }

    gibbon.ecommerce.stores(STORE_ID).products(product.sku).variants.create(body: variant_params)
  end
end
