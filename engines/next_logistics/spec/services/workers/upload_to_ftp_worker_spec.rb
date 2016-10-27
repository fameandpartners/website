require 'spec_helper'
require 'sidekiq/testing/inline'

module NextLogistics
  describe Workers::UploadToFtpWorker, type: :worker do
    let!(:order_return_request) { create(:order_return_request) }
    let!(:return_request_process) { ReturnRequestProcess.create(order_return_request: order_return_request) }

    subject(:worker) { described_class.new }

    context 'given a return request process ID' do
      let(:ftp_double) { instance_double(FTP::Interface) }

      before(:each) do
        expect(FTP::Interface).to receive(:new).and_return(ftp_double)
      end

      it 'uploads receipt file to Next FTP and proceed to next stage' do
        expect(ftp_double).to receive(:upload).with(file: an_instance_of(Tempfile))

        worker.perform(return_request_process.id)

        return_request_process.reload
        expect(return_request_process.aasm_state).to eq('asn_file_uploaded')
      end
    end

    context 'an exception is raised' do
      let(:sentry_error) { double('Sentry Error', id: 'sentry-error-id') }

      it 'mark process as failed and save Error ID' do
        expect(FTP::Receipt).to receive(:new).and_raise(StandardError)
        expect(Raven).to receive(:capture_exception).with(StandardError).and_return(sentry_error)

        worker.perform(return_request_process.id)

        return_request_process.reload
        expect(return_request_process.error_id).to eq('sentry-error-id')
        expect(return_request_process.failed).to eq(true)
      end
    end
  end
end
