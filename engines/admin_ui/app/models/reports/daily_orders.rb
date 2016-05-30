module Reports
  class DailyOrders
    include RawSqlCsvReport

    def initialize(from:, to:)
      raise ArgumentError unless from.respond_to?(:to_date)
      raise ArgumentError unless to.respond_to?(:to_date)

      @from = from.to_datetime.beginning_of_day
      @to   = to.to_datetime.end_of_day
    end

    def from
      @from.to_s
    end

    def to
      @to.to_s
    end

    def description
      'Daily Orders'
    end

    def filename
      [
        description,
        'from',
        @from.to_date.to_s(:filename),
        'to',
        @to.to_date.to_s(:filename),
        'generated',
        DateTime.now.to_s(:filename),
      ].join('_') << ".csv"
    end

    def to_sql
      Spree::Order::FastOrder.get_sql report: :daily_orders, from_date: from, to_date: to
    end

    def report_csv
      CSV.generate(headers: true) do |csv|
        csv << report_headers

        self.each do |r|
          line = Orders::LineItemCSVPresenter.new r
          csv << [
            line.order_number,
            line.site_version,
            line.total_items,
            line.promo_codes,
            line.price,
            line.currency,
            line.style,
            line.line_item_id,
            line.size,
            line.adjusted_size,
            line.height,
            line.color,
            line.quantity,
            line.factory,
            line.delivery_date,
            line.fast_making,
            line.customization_values,
            line.custom_color,
            line.customer_notes,
            line.customer_name,
            line.customer_phone_number,
            line.email,
            line.shipping_address,
            line.image
          ]
        end
      end
    end

    def report_headers
      en_headers.collect { |k| "#{k} #{cn_headers[k]}" }
    end

    def en_headers
      [
        :order_number,
        :site_version,
        :total_items,
        :promo_codes,
        :payment_total,
        :currency,
        :style,
        :line_item_id,
        :size,
        :adjusted_size,
        :height,
        :color,
        :quantity,
        :factory,
        :projected_delivery_date,
        :express_making,
        :customisations,
        :custom_color,
        :customer_notes,
        :customer_name,
        :customer_phone_number,
        :email,
        :shipping_address,
        :image
      ]
    end

    def cn_headers
      {
        order_number:            '(订单号码)',
        express_making:          '(快速决策)',
        projected_delivery_date: '(要求出厂日期)',
        style:                   '(款号)',
        factory:                 '(工厂)',
        color:                   '(颜色)',
        size:                    '(尺寸)',
        customisations:          '(特殊要求)',
        customer_name:           '(客人名字)',
        customer_phone_number:   '(客人电话)',
        shipping_address:        '(客人地址)'
      }
    end

  end
end
