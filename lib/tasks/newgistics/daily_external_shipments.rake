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
    last_successful_run = scheduler.last_successful_run
    return_request_items = ReturnRequestItem.where('created_at >= ?', last_successful_run) # get returns initiated since last run
    return_request_items = ReturnRequestItem.last(5) if ENV['SIMULATE']=="1"

    puts "Daily upload return list begin: from "+last_successful_run+" to "+ current_time.to_s
    generate_csv(return_request_items)
    scheduler.last_successful_run = current_time.to_s
    scheduler.save unless ENV['DRY_RUN']=='1'
  end

  def generate_csv(return_request_items)
    csv_headers = ['OrderId', 'FirstName', 'LastName', 'Address1', 'Address2', 'City', 'State','PostalCode',
                   'CountryCode', 'Tracking', 'SKU', 'Quantity']
    temp_file = Tempfile.new('foo')  # self GC temp_file
    #temp_file = File.new("/home/544.csv", "w+")
    csv_file = CSV.open(temp_file, 'wb') do |csv|
      csv << csv_headers # set headers for csv
      return_request_items.each do |return_request|
        order = return_request.order
        if order.nil?
          puts "order is nil, return request id: " + return_request.id.to_s
          next
        end

        li = return_request.line_item
        if li.nil?
          puts "line item is nil, return request id: " + return_request.id.to_s
          next
        end

        address = order.ship_address
        state_name = ''
        if address.state.nil?
          puts "address no state， order id: " + order.number + ", return request id: " + return_request.id.to_s
          puts "address: " + address.firstname + ", " +
                 address.lastname + ", " +
                 address.address1 + ", " +
                 address.address2 + ", " +
                 address.city + ", " +
                 address.zipcode + ", " +
                 address.country.name
        else
          state_name = address.state.name
        end

        if address.country_id == 49 ||  COUNTRY_ARRAY.include?(address.country.name)
        csv << [order.number, address.firstname, address.lastname, address.address1,
                address.address2, address.city, state_name, address.zipcode, address.country.iso,
                (return_request.item_return.item_return_label.barcode.to_s rescue ""),
                CustomItemSku.new(li).call, '1']
        end
      end
    end

    if Rails.env.production?
      # TODO REMOVE ME
      ActionMailer::Base.mail(from: "noreply@fameandpartners.com",
                              to: "davidp@fameandpartners.com",
                              cc: "jonathanv@fameandpartners.com;hzsoft@graphicchina.com",
                              subject: "rake newgistics:upload_return_list",
                              body: temp_file.read).deliver
    end

    if Rails.env.production?
      temp_file.rewind
      Net::SFTP.start(configatron.newgistics.ftp_uri,
                      configatron.newgistics.ftp_user,
                      password: configatron.newgistics.ftp_password) do |sftp|
        sftp.upload!(temp_file, "input/External Shipments/#{Date.today.to_s}.csv")
      end
    temp_file.close
    end
  end
end
