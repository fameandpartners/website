require 'roo'

namespace :import do
  namespace :product do

    desc 'Reindex all products'
    task :reindex => :environment do
      Utility::Reindexer.reindex
    end

    desc 'prices'
    task :prices => :environment do
      raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

      file_path = ENV['FILE_PATH']

      if file_path =~ /\.xls$/
        book = Roo::Excel.new(file_path, false, :warning)
      elsif file_path =~ /\.xlsx$/
        book = Roo::Excelx.new(file_path, false, :warning)
      else
        raise 'Invalid file type'
      end

      book.default_sheet = book.sheets.first

      (book.first_row..book.last_row).each do |index|
        sku, price = book.row(index)
        sku = sku.dup.to_s.downcase.strip

        next if sku.blank? || price.blank?

        puts %Q(Search product by SKU "#{sku}")

        masters = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku)

        if masters.blank?
          puts %q(  Products not found)
          next
        end

        puts %Q(  #{masters.count} products found)

        masters.each do |master|
          puts %Q(    Processing master variant with id "#{master.id}")
          master.price = price
          master.save!
          puts %q(      Saved)

          master.product.variants.each do |variant|
            puts %Q(    Processing variant with id "#{variant.id}")
            variant.price = price
            variant.save!
            puts %q(      Saved)
          end
        end
      end
    end
  end
end
