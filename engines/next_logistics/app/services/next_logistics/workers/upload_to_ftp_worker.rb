module NextLogistics
  module Workers
    class UploadToFtpWorker < BaseWorker
      def perform(return_request_process_id)
        process  = ReturnRequestProcess.find(return_request_process_id)
        receipt  = FTP::Receipt.new(return_request_process: process)
        ftp      = FTP::Interface.new
        tempfile = receipt.tempfile

        ftp.upload(file: tempfile)
        process.asn_file_was_uploaded!
        tempfile.unlink
      rescue StandardError => e
        sentry_error = Raven.capture_exception(e)
        process.update_column(:error_id, sentry_error.id)
        process.update_column(:failed, true)
      end
    end
  end
end
