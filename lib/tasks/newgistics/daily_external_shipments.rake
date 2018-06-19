# coding: utf-8
# frozen_string_literal: true

# uploads all order returns initiated since last scheduled run
require 'csv'
require 'tempfile'
require 'net/ftp'
namespace :newgistics do
  task upload_return_list: :environment do
    COUNTRY_ARRAY = ["Canada",
                     "Mexico",
                     "Albania",
                     "Andorra",
                     "Armenia",
                     "Austria",
                     "Azerbaijan",
                     "Belarus",
                     "Belgium",
                     "Bosnia and Herzegovina",
                     "Bulgaria",
                     "Croatia",
                     "Cyprus",
                     "Czech Republic",
                     "Denmark",
                     "Estonia",
                     "Finland",
                     "France",
                     "Georgia",
                     "Germany",
                     "Greece",
                     "Hungary",
                     "Iceland",
                     "Ireland",
                     "Italy",
                     "Kazakhstan",
                     "Kosovo",
                     "Latvia",
                     "Liechtenstein",
                     "Lithuania",
                     "Luxembourg",
                     "Macedonia",
                     "Malta",
                     "Moldova",
                     "Monaco",
                     "Montenegro",
                     "Netherlands",
                     "Norway",
                     "Poland",
                     "Portugal",
                     "Romania",
                     "Russia",
                     "San Marino",
                     "Serbia",
                     "Slovakia",
                     "Slovania",
                     "Spain",
                     "Sweden",
                     "Switzerland",
                     "Turkey",
                     "Ukraine",
                     "United Kingdom ",
                     "Holy See (Vatican City)",
                     "Argentina",
                     "Bolivia",
                     "Brazil",
                     "Chile",
                     "Colombia",
                     "Ecuador",
                     "Guyana",
                     "Paraguay",
                     "Peru",
                     "Suriname",
                     "Uruguay",
                     "Venezuela",
                     "Belize",
                     "Costa rica",
                     "El Salvador",
                     "Guatemala",
                     "Honduras",
                     "Panama",
                     "Cuba",
                     "Dominican Republic",
                     "Haiti",
                     "Guadeloupe",
                     "Martinique",
                     "Puerto Rico",
                     "Saint-Barthélemy",
                     "Saint-Martin"
    ]
    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('daily_returns')).nil?
        scheduler = Newgistics::NewgisticsScheduler.new
        scheduler.last_successful_run = 5.day.ago.utc.to_datetime.to_s
        scheduler.name = 'daily_returns'
        scheduler.save unless ENV['DRY_RUN']=='1'
    end
    current_time = Date.today.beginning_of_day.utc.to_datetime.to_s

    return_request_items = ReturnRequestItem.where('created_at >= ?', scheduler.last_successful_run) # get returns initiated since last run
    return_request_items = ReturnRequestItem.last(5) if ENV['SIMULATE']=="1"


    generate_csv(return_request_items)
    scheduler.last_successful_run = current_time.to_s
    scheduler.save unless ENV['DRY_RUN']=='1'
  end

  def generate_csv(return_request_items)
    csv_headers = ['OrderId', 'FirstName', 'LastName', 'Address1', 'Address2', 'City', 'State','PostalCode',
                   'CountryCode', 'Tracking', 'SKU', 'Quantity']
    temp_file = Tempfile.new('foo')  # self GC temp_file
    csv_file = CSV.open(temp_file, 'wb') do |csv|
      csv << csv_headers # set headers for csv
      return_request_items.each do |return_request|
        order = return_request.order
        barcode_exists = return_request.item_return.item_return_label.barcode rescue nil
          unless barcode_exists
            puts "DB8 Skipping Order due to no barcode #{order.id} #{order.created_at}"
            next
          end
        li = return_request.line_item
        address = order.ship_address

        if address.country_id == 49 ||  COUNTRY_ARRAY.include?(address.country.name)
        csv << [order.number, address.firstname, address.lastname, address.address1,
                address.address2, address.city, address.state.name, address.zipcode, address.country.iso,
                (return_request.item_return.item_return_label.barcode.to_s rescue ""),
                CustomItemSku.new(li).call, '1']
        end
      end
    end

    if ENV['DRY_RUN']=='1'
      puts `cat #{temp_file.path}`
    else
      Net::SFTP.start(configatron.newgistics.ftp_uri,
                      configatron.newgistics.ftp_user,
                      password: configatron.newgistics.ftp_password) do |sftp|
      sftp.upload!(temp_file, "input/External Shipments/#{Date.today.to_s}.csv")
      end
    end
  end
end
