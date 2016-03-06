module AdminUi
  module Reports
    class StreamingCsvController < AdminUi::ApplicationController

      helper_method :report

      def show
        @rows = report.take(10).map &:to_h
      end

      # Streaming CSV download.
      # See: http://smsohan.com/blog/2013/05/09/genereating-and-streaming-potentially-large-csv-files-using-ruby-on-rails/
      def create
        headers["Content-Type"]        = "text/csv"
        headers["Content-disposition"] = "attachment; filename=\"#{filename}\""
        headers['X-Accel-Buffering']   = 'no'
        headers["Cache-Control"]       ||= "no-cache"
        headers.delete("Content-Length")

        response.status    = 200
        self.response_body = report.to_csv_rows
      end

      private

      def filename
        [
          report.description,
          'generated',
          DateTime.now.to_s(:filename),
        ].join('_') << ".csv"
      end

      def report
        raise 'Not Implemented'
      end
    end
  end
end
