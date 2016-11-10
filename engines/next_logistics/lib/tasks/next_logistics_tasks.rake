namespace :next do
  namespace :workers  do

    # each 30 minutes
    desc 'Upload ASN requests to Next Logistics FTP'
    task asn_file_upload: :environment do
      NextLogistics::ReturnRequestProcess.not_failed.created.find_each do |return_request_process|
        return_request_process.upload_to_ftp
      end
    end
  end
end
