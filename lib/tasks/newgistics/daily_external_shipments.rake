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
        if Rails.env.production?
          scheduler.save unless ENV['DRY_RUN']=='1'
        end
    end
    current_time = Date.today.beginning_of_day.utc.to_datetime.to_s
    puts "last successfull run: " + scheduler.last_successful_run.to_s
    last_successful_run_time = Time.parse(scheduler.last_successful_run.to_s).utc
    while last_successful_run_time < current_time do
      one_day_after_last_successful_run_time = (last_successful_run_time + 1.day).utc

      return_request_items = ReturnRequestItem.where('created_at >= ? and created_at <= ?',
      last_successful_run_time.to_s, one_day_after_last_successful_run_time.to_s) # get returns initiated since last run
      puts ReturnRequestItem.where('created_at >= ? and created_at <= ?',
      last_successful_run_time.to_s, one_day_after_last_successful_run_time.to_s).to_sql

      generate_csv(return_request_items,last_successful_run_time)

      scheduler.last_successful_run = one_day_after_last_successful_run_time.to_s
      last_successful_run_time = Time.parse(scheduler.last_successful_run.to_s).utc
    end

    if Rails.env.production?
      scheduler.save unless ENV['DRY_RUN']=='1'
    end
  end

  def generate_csv(return_request_items,time)
    csv_headers = ['OrderId', 'FirstName', 'LastName', 'Address1', 'Address2', 'City', 'State','PostalCode',
                   'CountryCode', 'Tracking', 'SKU', 'Quantity']
    #temp_file = Tempfile.new('foo')  # self GC temp_file
    temp_file = File.new("export\\#{time.year}#{time.month}#{time.day}.csv", "w+")
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
                              cc: "catherinef@fameandpartners.com",
                              subject: "rake newgistics:upload_return_list",
                              body: temp_file.read).deliver
    end

    if Rails.env.production?
      temp_file.rewind
      Net::SFTP.start(configatron.newgistics.ftp_uri,
                      configatron.newgistics.ftp_user,
                      password: configatron.newgistics.ftp_password) do |sftp|
        #sftp.upload!(temp_file, "input/External Shipments/#{Date.today.to_s}.csv")
        puts ("ftp_uri: " + configatron.newgistics.ftp_uri)
        puts ("ftp_user: " + configatron.newgistics.ftp_user)
        puts ("ftp_password: " + configatron.newgistics.ftp_password)
        sftp.upload!(temp_file, "input/untitled folder/#{Date.today.to_s}.csv")
      end
    end
    temp_file.close
   end
end
