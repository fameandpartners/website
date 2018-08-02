class ProductionOrderEmailService
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def deliver
    order.line_items.group_by{ |i|i.factory }.each do |factory, items|
      trigger_email(order, factory, items)
    end
  end

  def trigger_email(order, factory, items)
    items = items.select{|item| item.stock.nil? && !item.fabric_swatch? && !item.return_insurance?}
    if items.any?
      FactoryPurchaseOrderEmail.new(order, factory, items).deliver
    end
  end

  class FactoryPurchaseOrderEmail
    attr_reader :order_presenter, :factory, :factory_items, :raw_order

    def initialize(order, factory, factory_items)
      @raw_order       = order
      @factory         = factory
      @factory_items   = factory_items
    end

    def order_presenter
      @order_presenter ||= Orders::OrderPresenter.new(raw_order, factory_items)
    end

    def delivery_email
      configatron.order_production_emails
    end

    def deliver
      subject = "Order Confirmation (订单号码）(#{factory.name}) ##{order_presenter.number}"

      user = raw_order.user
      user ||= Spree::User.where(email: order_presenter.email).first

      line_items = order_presenter.extract_line_items

      Marketing::CustomerIOEventTracker.new.track(
        user,
        'order_production_order_email',
        email_to:           delivery_email,
        subject:            subject,
        number:             order_presenter.number,
        site:               order_presenter.site_version,
        total_items:        order_presenter.total_items,
        promotion:          order_presenter.promotion?,
        promocode:          order_presenter.promo_codes.join(', '),
        line_items:         line_items,
        customer_notes:     order_presenter.customer_notes?,
        customer_note_data: order_presenter.customer_notes,
        customer:           order_presenter.name,
        phone:              order_presenter.phone_number,
        shipping_address:   order_presenter.shipping_address.to_s,
        factory:            factory.name,
        display_total:      order_presenter.display_total.to_s,
        currency:           order_presenter.currency,
        cny_delivery_delay: Features.active?(:cny_delivery_delays)
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
      Raven.capture_exception(e)
    end
  end
end
