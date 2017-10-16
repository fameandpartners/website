# frozen_string_literal: true
require 'csv'
require 'tempfile'
require 'net/ftp'
namespace :newgistics do
  task update_return_labels: :environment do
    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('shipment_ftp')).nil?
      scheduler = Newgistics::NewgisticsScheduler.new
      scheduler.last_successful_run = 1.day.ago.utc.to_datetime.to_s
      scheduler.name = 'shipment_ftp'
      scheduler.save
    end
    current_time = Date.today.beginning_of_day.utc.to_datetime.to_s
    client = Newgistics::NewgisticsClient.new
    res = client.get_shipped_returns(scheduler.last_successful_run, current_time)
    if res['response'].nil?
      NewRelic::Agent.notice_error(res.to_s)
      Raven.capture_exception(res.to_s)
    elsif  !res['response'].key('Shipments')
      NewRelic::Agent.notice_error(res['response'].to_s)
      Raven.capture_exception(res['response'].to_s)
    else
      generate_csv(res['response']['Shipments'])
    end
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end

  def generate_csv(shipments)
    csv_headers = ['PurchaseOrder', 'Name', 'ShippedDate', 'ArrivalDate','ProductSKU', 'ManifestDetailOriginalQty']
    temp_file = Tempfile.new('foo')
    csv_file = CSV.open(temp_file, "wb") do |csv|
      csv << csv_headers
      shipments.each do |shipment|
        shipment['Items'].each do |item|
            csv << [shipment['PurchaseOrder'], "#{shipment['FirstName']} #{shipment['LastName']}'s return of #{item['SKU']}",
                    shipment['ShippedDate'], shipment['ExpectedDeliveryDate'], item['SKU'], item['Qty']]
          end
      end
    end
    ftp = Net::FTP.new(configatron.newgistics.ftp_uri)
    ftp.login(configatron.newgistics.ftp_user, configatron.newgistics.ftp_password)
    ftp.putbinaryfile(temp_file, "\\FameandPartners\\input\manifests\\#{Date.today.to_s}.csv", 1024)
    ftp.close
  end

end
