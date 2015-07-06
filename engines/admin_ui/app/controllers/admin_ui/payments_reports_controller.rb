module AdminUi
  class PaymentsReportsController < AdminUi::ApplicationController

    def show
      @rows = model_class.new.take(10).map &:to_h
    end

    # Streaming CSV download.
    # See: http://smsohan.com/blog/2013/05/09/genereating-and-streaming-potentially-large-csv-files-using-ruby-on-rails/
    def create
      file_name                      = "payments_up_to_#{DateTime.now.to_s(:filename)}.csv"
      headers["Content-Type"]        = "text/csv"
      headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
      headers['X-Accel-Buffering']   = 'no'
      headers["Cache-Control"]       ||= "no-cache"
      headers.delete("Content-Length")

      response.status    = 200
      self.response_body = model_class.new.to_csv_rows
    end

    def model_class
      ::PaymentsReport
    end
  end
end
