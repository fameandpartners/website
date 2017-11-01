# frozen_string_literal: true

# uploads all order returns initiated since last scheduled run
require 'csv'
require 'tempfile'
require 'net/ftp'
namespace :newgistics do
  task upload_return_list: :environment do
    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('daily_returns')).nil?
      scheduler = Newgistics::NewgisticsScheduler.new
      scheduler.last_successful_run = 5.day.ago.utc.to_datetime.to_s
      scheduler.name = 'daily_returns'
      scheduler.save
    end

    return_request_items = ReturnRequestItem.where('created_at >= ?', scheduler.last_successful_run) # get returns initiated since last run

    generate_csv(return_request_items)
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end

  def generate_csv(return_request_items)
    csv_headers = ['OrderId', 'FirstName', 'LastName', 'Address1', 'Address2', 'City', 'State','PostalCode',
                   'CountryCode', 'Tracking', 'SKU', 'Quantity']
    temp_file = Tempfile.new('foo')  # self GC temp_file
    csv_file = CSV.open(temp_file, 'wb') do |csv|
      csv << csv_headers # set headers for csv
      return_request_items.each do |return_request|
        order = order_return.order
        li = order_return.line_item
        address = order.ship_address
        csv << [order.number, address.firstname, address.lastname, address.address1,
                address.address2, address.city, address.state.name, address.zipcode, address.country.iso2,
                return_request.item_return.item_return_label.barcode, CustomItemSku.new(li).call, '1']
      end
    end
    Net::SFTP.start(configatron.newgistics.ftp_uri,
                    configatron.newgistics.ftp_user,
                    password: configatron.newgistics.ftp_password) do |sftp|
    sftp.upload!(temp_file, "\\FameandPartners\\input\\external shipments\\#{Date.today.to_s}.csv")
    end
  end

end
