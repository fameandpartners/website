require 'reports/order_totals'

module AdminUi
  module Reports
    class DailyOrdersController < AdminUi::Reports::StreamingCsvController

    def show
      @rows = CSV.parse(report_csv).map {|a| Hash[ headers_en.zip(a) ] }[1..10]
    end

    private

      def report
        ::Reports::DailyOrders.new(from: from_date, to: to_date)
      end

      def report_csv
        CSV.generate(headers: true) do |csv|
          csv << headers_en

          report.each do |r|
            csv << [
              r['order_number'],
              r['site_version'],
              r['total_items'],
              r['promo_codes'],
              price(r),
              r['currency'],
              r['style'],
              r['line_item_id'],
              r['size'],
              adjusted_size(r),
              r['height'],
              r['color'],
              r['quantity'],
              r['factory'],
              delivery_date(r),
              r['fast_making'].present? ? "TRUE" : '',
              customization_values(r),
              r['customer_notes'],
              customer_name(r),
              r['customer_phone_number'] || 'No Phone',
              r['email'],
              shipping_address(r).present? ? shipping_address(r) : 'No Shipping Address',
              r['variant_image'],
              r['custom_variant_image'],
              r['product_image']
            ]
          end
        end
      end

      def filename
        [
          report.description,
          'from',
          from_date.to_s(:filename),
          'to',
          to_date.to_s(:filename),
          'generated',
          DateTime.now.to_s(:filename),
        ].join('_') << ".csv"
      end

      def from_date
        date(params[:from], default: 7.weeks.ago)
      end

      def to_date
        date(params[:to], default: Date.today)
      end

      def date(parameter, default: default)
        if parameter.present?
          Date.parse(parameter.to_s).to_date
        else
          default
        end
      rescue StandardError => e
        default
      end

      def headers_en
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
            :delivery_date,
            :making_options,
            :customisations,
            :customer_notes,
            :customer_name,
            :customer_phone_number,
            :email,
            :shipping_address,
            :variant_image,
            :custom_variant_image,
            :product_image
          ]
        end

      def price(r)
        r['price'].to_f + r['personalization_price'].to_f + r['making_options_price'].to_f
      end

      def adjusted_size(r)
        "#{r['size']} (#{r['site_version']})"
      end

      def delivery_date(r)
        return unless r['completed_at_char'].present?
        Policies::LineItemProjectedDeliveryDatePolicy.new(r['completed_at_char'].to_date, r['fast_making']).delivery_date
      end

      def customization_values(r)
        if r['personalization'].present?
          values = YAML.load(r['customization_value_ids'])
          customs = values.present? ? CustomisationValue.where(id: values).pluck(:presentation) : []
          customs << ["Custom Color: #{color_name(r)}"] unless r['custom_color']
          customs.join('|')
        else
          'N/A'
        end
      end

      def customer_name(r)
        "#{r['user_first_name']} #{r['user_last_name']}"
      end

      def shipping_address(r)
        "#{r['address1']} #{r['address2']} #{r['city']} #{r['state']} #{r['zipcode']} #{r['country']}"
      end

    end
  end
end
