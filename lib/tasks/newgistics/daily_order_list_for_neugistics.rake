# frozen_string_literal: true

# uploads all completed orders since last scheduled run
require 'csv'
require 'tempfile'
require 'net/sftp'

namespace :newgistics do
  task upload_order_list: :environment do
    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('daily_orders')).nil?
      scheduler = Newgistics::NewgisticsScheduler.new
      scheduler.last_successful_run = 5.day.ago.utc.to_datetime.to_s
      scheduler.name = 'daily_orders'
      scheduler.save
    end
    current_time = Date.today.beginning_of_day.utc.to_datetime.to_s

    orders = Spree::Order.where("completed_at >= ? AND state = 'complete'", scheduler.last_successful_run) # get complete orders

    generate_csv_for_orders(orders)
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end

  def generate_csv_for_orders(orders)
    csv_headers = ['Order Id', 'Order Date', 'First Name', 'Last Name','Company', 'Address Line 1',
                   'Address Line 2', 'City', 'State','Zip Code', 'Country', 'Customer Email', 'Customer Phone',
                   'Customer Fax', 'Ship Method Code', 'Pack Slip Info Line', 'Contents List (SKU, Qty)',
                   'Declared Value', 'Description of Contents', 'Product Country of Origin', 'Expected Weight', 'Warehouse', 'Drop Ship Name']
    temp_file = Tempfile.new('foo')  # self GC temp_file
    csv_file = CSV.open(temp_file, 'wb') do |csv|
      csv << csv_headers # set headers for csv
      orders.each do |order|
        address = order.ship_address
        usr_email = address.email.length  > 50 ? 'cs@fameandpartners.com' : address.email #max character length is 50 for newgistics
        
        csv << [order.number, order.completed_at, address.firstname, address.lastname, '', address.address1,
        address.address2, address.city, address.state.name, address.zipcode, address.country.iso,
        usr_email, address.phone,'', '', 'NPS', order.line_items.reject{|x| x.product.name.downcase == 'return_insurance'}.map {|li| "#{CustomItemSku.new(li).call},1"}.join(','),
        order.total, order.line_items.reject{|x| x.product.name.downcase == 'return_insurance'}.map { |li|li.product.name}.join(','), 'CN', '', '', '']
      end
    end
    Net::SFTP.start(configatron.newgistics.ftp_uri,
                    configatron.newgistics.ftp_user,
                    password: configatron.newgistics.ftp_password) do |sftp|
      sftp.upload!(temp_file, "FameandPartners/input/shipments/#{Date.today.to_s}.csv")
    end
  end

end
