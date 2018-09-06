# frozen_string_literal: true

# uploads all products that have been purchased since last scheduled run.
require 'csv'
require 'tempfile'
require 'net/sftp'
namespace :newgistics do
  task upload_product_list: :environment do
    Rails.logger.debug "DB8 Test" # sadly this doesn't appear in logs anywhere

    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('daily_products')).nil?
      scheduler = Newgistics::NewgisticsScheduler.new
      scheduler.last_successful_run = 1.day.ago.utc.to_datetime.to_s
      scheduler.name = 'daily_products'
      scheduler.save
    end
    current_time = Date.today.beginning_of_day.utc.to_datetime.to_s

    line_items = Spree::LineItem.where('updated_at >= ?',  30.days.ago.utc.to_datetime.to_s)
                                .reject{|x| x.product.name.downcase == 'return_insurance'}
                                .select { |li| li.order.state == 'complete' && li.order.completed_at >=  30.days.ago.utc.to_datetime.to_s} # get line Items for completed orders since last run
    unique_items = line_items&.uniq { |li| CustomItemSku.new(li).call } # only care about unique skus

    generate_csv_products(unique_items)
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end

  def generate_csv_products(line_items)
    csv_headers = ['SKU', 'Description', 'WeightInOunces','Height', 'Width', 'Depth', 'Value',
                   'RetailValue','UPC', 'Category', 'Supplier', 'Notes',
                   'SupplierCode', 'Image URL', 'HarmonizationCode', 'ProductCountryOfOrigin']
    temp_file = Tempfile.new('foo') # Creates self garbage collecting temp file
    csv_file = CSV.open(temp_file, 'wb') do |csv|
      csv << csv_headers # set headers
      line_items.each do |li|
        product = li.product
        lip = Orders::LineItemPresenter.new(li)
        sku = CustomItemSku.new(li).call

        # https://app.asana.com/0/791202471134961/802917601473069
        # Newgistics can't handle sku's over 60 chars in length
        next if sku.size > 59

        csv << [sku, product.name, '', '', '',
                '', format('%.2f', li.price / 2), format('%.2f', li.price),
                GlobalSku.find_or_create_by_line_item(line_item_presenter: lip).upc, product.category&.category, product.factory.name, '',
                CustomItemSku.new(li).call, product.images&.first&.attachment&.url, '', 'CN']
      end
    end

    puts "DB8"
    puts temp_file.read
    if Rails.env.production?
      # TODO REMOVE ME
      ActionMailer::Base.mail(from: "noreply@fameandpartners.com",
                              to: "samw@fameandpartners.com",
                              cc: "catherinef@fameandpartners.com",
                              subject: "rake newgistics:upload_product_list",
                              body: temp_file.read).deliver
      sleep 0.5
    end

    if Rails.env.production?
      temp_file.rewind
      Net::SFTP.start(configatron.newgistics.ftp_uri,
                      configatron.newgistics.ftp_user,
                      password: configatron.newgistics.ftp_password) do |sftp|
        sftp.upload!(temp_file, "input/products/#{Date.today}.csv")
      end
    end
  end
end
