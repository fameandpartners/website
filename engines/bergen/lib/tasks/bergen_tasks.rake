namespace :bergen do
  namespace :workers  do

    # each 30 minutes
    desc 'Verify style master with Bergen, creating it or advancing return items processes'
    task verify_style_masters: :environment do
      Bergen::Operations::ReturnItemProcess.not_failed.operation_created.find_each do |return_item_process|
        return_item_process.verify_style_master
      end
    end

    # each 30 minutes
    desc 'Create ASNs for processes with valid style masters'
    task create_asns: :environment do
      Bergen::Operations::ReturnItemProcess.not_failed.style_master_created.find_each do |return_item_process|
        return_item_process.create_asn
      end
    end

    # each 3 hours
    desc 'Verify received ASNs master with Bergen'
    task receive_asns: :environment do
      Bergen::Operations::ReturnItemProcess.not_failed.asn_created.find_each do |return_item_process|
        return_item_process.receive_asn
      end
    end
  end
end
