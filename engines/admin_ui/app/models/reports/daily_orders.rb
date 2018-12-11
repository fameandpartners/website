module Reports
  class DailyOrders
    include RawSqlCsvReport

    def initialize(from:, to:, is_report: false)
      raise ArgumentError unless from.respond_to?(:to_date)
      raise ArgumentError unless to.respond_to?(:to_date)
      unless is_report
        @from = from.to_datetime.beginning_of_day
        @to   = to.to_datetime.end_of_day
      else
        @from = from
        @to = to
      end
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
        @from.to_s(:filename),
        'to',
        @to.to_s(:filename),
        'generated',
      ].join('_') << ".csv"
    end

    def report_query
      Spree::Order.hydrated.completed.where('completed_at > ? and completed_at <= ?', from, to).flat_map(&:line_items)
    end

    def report_csv
      CSV.generate(headers: true) do |csv|
        csv << report_headers

        self.each do |line|

          if line.ignore_line?
            next
          end

          csv << [
            line.order.number,
            line.order.site_version,
            line.order.legit_line_items.count,
            line.order.completed_at&.to_date,
            line.order.promotions.map(&:name).join("|"),
            line.price,
            line.currency,
            line.product_sku,
            line.product.name,
            line.id,
            line.size&.presentation,
            line.personalization&.height,
            line.color&.presentation,
            line.quantity,
            line.factory,
            line&.ship_by_date&.to_date,
            line.making_options.map(&:product_making_option).map(&:making_option ).map(&:code).join("|"),
            line.new_sku,
            line.personalization&.customization_values&.map { |c| c['customisation_value']['presentation']}&.join("|"),
            line.fabric&.material,
            line.order.customer_notes,
            line.order.ship_address.name,
            line.order.ship_address.phone,
            line.order.email,
            line.order.ship_address.to_s,
            line.image_url,
            line.production_sheet_url
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
        :order_date,
        :promo_codes,
        :payment_total,
        :currency,
        :style,
        :style_name,
        :line_item_id,
        :size,
        :height,
        :color,
        :quantity,
        :factory,
        :ship_by_daye,
        :making,
        :sku,
        :customisations,
        :fabric,
        :customer_notes,
        :customer_name,
        :customer_phone_number,
        :email,
        :address,
        :image,
        :production_sheet_url
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
