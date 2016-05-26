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
            :custom_color,
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

    end
  end
end
