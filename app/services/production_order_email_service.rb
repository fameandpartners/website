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
    FactoryPurchaseOrderEmail.new(order, factory, items).deliver
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
      subject = "Order Confirmation (订单号码）(#{factory}) ##{order_presenter.number}"

      user = raw_order.user
      user ||= Spree::User.where(email: order_presenter.email).first

      line_items = extract_line_items

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
        shipping_address:   order_presenter.shipping_address,
        factory:            factory,
        display_total:      order_presenter.display_total,
        currency:           order_presenter.currency
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end

    def extract_line_items
      order_presenter.line_items.collect do |item|
        {
          style_num:        item.style_number,
          sku:              item.sku,
          product_number:   item.product_number,
          size:             item.size,
          adjusted_size:    item.country_size,
          color:            item.colour_name,
          height:           item.height,
          quantity:         item.quantity,
          factory:          item.factory,
          deliver_date:     item.projected_delivery_date,
          express_making:   item.making_options.present? ? item.making_options.map{|option| option.name.upcase }.join(', ') : "",
          image_url:        item.image? ? item.image_url : ''
        }.merge(
           # Convert each element of the customisations array
           # to an explicit hash key and child hash.
           #
           # Customizations is an array , currently customerio does not support nested array in json properly and they are working on it
           # that's why the json receive on customerio is not formatted correctly which lead to failed emails
           # a hacking solution is pull out all elements in customizations array to seperate elements so customerio can read correctly
           # Current output will be line_items[{... customizations: []....customizations_0: [], customizations_1: [], customizations_2: []...}, {}]
           #
           # e.g. Where we would like to use an array;
           # :customizations=>[{:name=>"N/A", :url=>nil}, {:name=>"Cool", :url=>nil} ]
           # we must use merge a hash to the original result
           # :customizations_0=>{:name=>"N/A", :url=>nil},
           # :customizations_1=>{:name=>"Cool", :url=>nil},
          item.customisations.each_with_index.map do |(name, image_url), idx|
            ["customizations_#{idx}".to_sym, {name: name, url: image_url}]
          end.to_h
        )
      end
    end
  end
end
