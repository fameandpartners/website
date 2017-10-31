# frozen_string_literal: true

# uploads all products that have been purchased since last scheduled run.
require 'csv'
require 'tempfile'
require 'net/sftp'
namespace :newgistics do
  task upload_product_list: :environment do
    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('daily_products')).nil?
      scheduler = Newgistics::NewgisticsScheduler.new
      scheduler.last_successful_run = 1.day.ago.utc.to_datetime.to_s
      scheduler.name = 'daily_products'
      scheduler.save
    end

    line_items = Spree::LineItem.where('updated_at >= ?', scheduler.last_successful_run)
                                .select { |li| li.order.state = 'complete' } # get line Items for completed orders since last run
    unique_items = line_items&.uniq { |li| CustomItemSku.new(li).call } # only care about unique skus

    generate_csv(unique_items)
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end

  def generate_csv(line_items)
    csv_headers = ['SKU', 'Description', 'WeightInOunces','Height', 'Width', 'Depth', 'Value',
                   'RetailValue','UPC', 'Category', 'Supplier', 'Notes',
                   'SupplierCode', 'Image URL', 'HarmonizationCode', 'ProductCountryOfOrigin']
    temp_file = Tempfile.new('foo') # Creates self garbage collecting temp file
    csv_file = CSV.open(temp_file, 'wb') do |csv|
      csv << csv_headers # set headers
      line_items.each do |li|
        product = li.product
        csv << [CustomItemSku.new(li).call, product.description, '', '', '',
                '', format('%.2f', li.price / 2), format('%.2f', li.price),
                GlobalSku.find_by_product_id(product.id).upc, product.category.category, product.factory.name, '',
                CustomItemSku.new(li).call, product.images&.first&.attachment&.url, '', 'CN']
      end
    end

    Net::SFTP.start(configatron.newgistics.ftp_uri,
                    configatron.newgistics.ftp_user,
                    password: configatron.newgistics.ftp_password) do |sftp|
      sftp.upload!(temp_file, "\\FameandPartners\\input\\products\\#{Date.today}.csv")
    end
  end
end
