require 'csv'

module Orders
  class LineItemCsvGenerator
    attr_reader :orders, :query_params

    def initialize(orders, query_params = {})
      @orders = orders
      @query_params = query_params
    end

    def filename
      parts = ['fp_orders']
      parts << Date.parse(query_params[:created_at_gt]).strftime('from_%Y-%m-%d') if query_params[:created_at_gt].present?
      parts << Date.parse(query_params[:created_at_lt]).strftime('to_%Y-%m-%d')   if query_params[:created_at_lt].present?
      parts << (query_params.fetch(:completed_at_not_null) { false } == '1' ? 'only_complete' : 'all_states')
      parts << 'generated_at'
      parts << DateTime.now.to_s(:file_timestamp)
      parts.join('_') << '.csv'
    end

    def headers
      en_headers.collect { |k| "#{k} #{cn_headers[k]}" }
    end

    def to_csv
      line = Orders::LineItemCSVPresenter

      CSV.generate(headers: true) do |csv|
        csv << headers
        orders.map do |order|
          line.set_line order.attributes

          li = Spree::LineItem.find_by_id(order.attributes["line_item_id"].to_i)
          lip = nil
          if li
            lip = Orders::LineItemPresenter.new(li)
          end

          csv << [
            line.order_state,
            line.order_number,
            lip.sample_sale?,
            line.line_item_id,
            line.total_items,
            line.completed_at_date,
            line.fast_making,
            lip&.projected_delivery_date&.to_date,
            # line.delivery_date,
            line.tracking_number,
            line.shipment_date,
            line.fabrication_state,
            line.style,
            line.style_name,
            line.factory,
            line.color,
            line.adjusted_size,
            line.height,
            line.customization_values,
            line.custom_color,
            line.promo_codes,
            line.email,
            line.customer_notes,
            line.customer_name,
            line.customer_phone_number,
            line.shipping_address,
            line.return_request,
            line.return_action,
            line.return_details,
            line.price,
            line.currency,
            line.product_number
          ]
        end
      end
    end

  private

    def en_headers
      [
        :order_state,
        :order_number,
        :sample_sale_item,
        :line_item,
        :total_items,
        :completed_at,
        :express_making,
        :ship_by_date,
        :tracking_number,
        :shipment_date,
        :fabrication_state,
        :style,
        :style_name,
        :factory,
        :color,
        :size,
        :height,
        :customisations,
        :custom_color,
        :promo_codes,
        :email,
        :customer_notes,
        :customer_name,
        :customer_phone_number,
        :shipping_address,
        :return_request,
        :return_action,
        :return_details,
        :price,
        :currency,
        :upc
      ]
    end

    def cn_headers
      {
        order_number:            '(订单号码)',
        completed_at:            '(订单日期)',
        express_making:          '(快速决策)',
        ship_by_date:            '(要求出厂日期)',
        tracking_number:         '(速递单号)',
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
