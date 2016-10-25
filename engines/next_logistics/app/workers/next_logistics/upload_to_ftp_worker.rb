module NextLogistics
  module Workers
    class UploadToFtpWorker < BaseWorker
      def perform(return_request_process_id)
        @return_request_process = NextLogistics::ReturnRequestProcess.find(return_request_process_id)
      rescue StandardError => e
        sentry_error = Raven.capture_exception(e)
        @return_request_process.update_column(:error_id, sentry_error.id)
        @return_request_process.update_column(:failed, true)
      end
    end
  end
end
