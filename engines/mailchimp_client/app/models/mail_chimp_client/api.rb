module MailChimpClient
  class API

    attr_reader :gibbon

    STORE_ID = 'fame_and_partners'

    def initialize
      @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    end

    def add_customer(user)
      return if customer_exists? user

      user_presenter = MailChimpClient::UserPresenter.new(user)
      user_params = user_presenter.read

      gibbon.ecommerce.stores(STORE_ID).customers.create(body: user_params)
    rescue StandardError => e
      puts e
      puts e.backtrace.join("\n\t")
      Raven.capture_exception(e)
    end

    def add_product(product)
      return unless product

      product_params = {
        id:       product.sku,
        title:    product.name,
        variants: [{ id: product.master.sku, title: product.master.sku }] # MailChimp will not create product without any variant
      }

      gibbon.ecommerce.stores(STORE_ID).products.create(body: product_params)
    end

    def add_variant(product, sku)
      return unless product && sku

      variant_params = {
        id:    sku,
        title: product.name,
        sku:   sku
      }

      gibbon.ecommerce.stores(STORE_ID).products(product.sku).variants.create(body: variant_params)
    end

    def add_order(order)
      return unless order

      order_params = MailChimpClient::OrderPresenter.new(order).read

      gibbon.ecommerce.stores(STORE_ID).orders.create(body: order_params)
    rescue StandardError => e
      puts e
      puts e.backtrace.join("\n\t")
      Raven.capture_exception(e)
    end

    def add_store
      return if store_exists?

      store_params = {
        id: STORE_ID,
        list_id: ENV['MAILCHIMP_LIST_ID'],
        name: 'Fame and Partners',
        currency_code: 'USD'
      }

      gibbon.ecommerce.stores.create(body: store_params)
    end

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

    def store_exists?
      gibbon.ecommerce.stores(STORE_ID).retrieve
      true
    rescue Gibbon::MailChimpError
      false
    end
  end
end
