require 'reports/sale_items'

module AdminUi
  module Reports
    class SaleItemsController < AdminUi::ApplicationController

      def show
        @rows = report.take(10).map &:to_h
      end

      # Streaming CSV download.
      # See: http://smsohan.com/blog/2013/05/09/genereating-and-streaming-potentially-large-csv-files-using-ruby-on-rails/
      def create
        # file_name                      = "payments_up_to_#{DateTime.now.to_s(:filename)}.csv"
        headers["Content-Type"]        = "text/csv"
        headers["Content-disposition"] = "attachment; filename=\"#{filename}\""
        headers['X-Accel-Buffering']   = 'no'
        headers["Cache-Control"]       ||= "no-cache"
        headers.delete("Content-Length")

        response.status    = 200
        self.response_body = report.to_csv_rows
      end

      private

      def report
        ::Reports::SaleItems.new(from: from_date, to: to_date)
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

      # lol programming
      def from_date
        date(params[:from], default: 1.week.ago)
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
    end
  end
end
